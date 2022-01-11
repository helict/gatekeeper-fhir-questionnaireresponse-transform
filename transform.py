#!/usr/bin/env python3
import argparse
import csv
import json
import logging
import re
from datetime import datetime
from pathlib import Path

def fhir_coding_type(arg_value, pattern = re.compile(r'^.+\|.+$')):
  if pattern.match(arg_value):
    return arg_value

  raise argparse.ArgumentTypeError

arg_parser = argparse.ArgumentParser(description = 'Transform FHIR Bundle with QuestionnaireResponse entries to CSV')
arg_parser.add_argument('-c', '--codes', help='Path to FHIR ConceptMap file with answer codes', type=Path, default=None)
arg_parser.add_argument('-d', '--dialect', help='Dialect used to format CSV', type=str, default='excel', choices=['excel', 'excel-tab', 'unix'])
arg_parser.add_argument('-l', '--logfile', help='Path to log file', type=Path, default=Path('./output.log'))
arg_parser.add_argument('-o', '--output', help='Path to CSV output file', type=Path, default=Path('./output.csv'))
arg_parser.add_argument('-t', '--tag', help='Resource tag for survey time formatted as \"system|code\"', type=fhir_coding_type)
arg_parser.add_argument('-v', '--verbosity', help='Verbosity of output', type=str, default='INFO', choices=['INFO', 'WARNING', 'DEBUG'])
arg_parser.add_argument('bundle', help='Path to FHIR JSON Bundle input file', type=Path)
args = arg_parser.parse_args()

logging.basicConfig(
  filename=args.logfile, 
  filemode='w',
  encoding='utf-8', 
  level=logging.getLevelName(args.verbosity),
  format='%(asctime)s %(levelname)-8s %(message)s',
  datefmt='%Y-%m-%d %H:%M:%S'
)

def load_answer_codes(answer_codes):
  if not answer_codes:
    return None

  code_map = {}

  logging.info('Load FHIR ConceptMap answer codes from file')
  with open(answer_codes) as json_file:
    concept_map = json.load(json_file)
  
  for group in concept_map['group']:
    source = group['source']
    logging.debug('Create answer code map for {}'.format(source))

    for element in group['element']:
      code_from = element['code']
      code_to = element['target'][0]['code']
      logging.debug('Map answer code from \'{}\' to \'{}\''.format(code_from, code_to))

      if not (source in code_map):
        code_map[source] = {}

      code_map[source][code_from] = code_to

  return code_map

def to_str(answer, prefix = '', separator = '|'):
  res = ''

  if ('valueBoolean' in answer):
    res = str(answer['valueBoolean']).lower()
  elif ('valueCoding' in answer):
    res = answer['valueCoding']['code']
  elif ('valueQuantity' in answer):
    res = answer['valueQuantity']['value']

    if ('comparator' in answer['valueQuantity']):
      comp = answer['valueQuantity']['comparator']
      res = '{}{}'.format(comp, res)
  else:
    res = answer[next(iter(answer))]

  if prefix:
    return '{}{}{}'.format(prefix, separator, res)
  else:
    return res

def extract_answers(items, questionnaire, answer_codes):
  answers = {}

  for item in items:
    variable = item['linkId']

    if 'answer' in item:
      for answer in item['answer']:
        answer = to_str(answer)

        if answer_codes and (questionnaire in answer_codes) and (answer in answer_codes[questionnaire]):
          logging.debug('Perform answer coding for answer: {}|{}'.format(variable, answer))
          answers.update({variable: answer_codes[questionnaire][answer]})
        else:
          logging.debug('Skip answer coding for answer: {}|{}'.format(variable, answer))
          answers.update({variable: answer})
    
    if 'item' in item:
        logging.info('Process nested items for item {}'.format(item['linkId']))
        answers.update(extract_answers(item['item'], questionnaire, answer_codes))

  return answers

def has_tag(resource, tag_arg):
  if resource and tag_arg:
    logging.debug('Check {}/{} for tag \"{}\"'.format(resource['resourceType'], resource['id'], tag_arg))
    if ('meta' in resource) and ('tag' in resource['meta']):
      separator = '|'
      system, code = tag_arg.split(separator)

      for tag in resource['meta']['tag']:
        if (tag['system'] == system) and (tag['code'] == code):
          logging.debug('Found tag \"{}\" in {}/{} '.format(tag_arg, resource['resourceType'], resource['id']))
          return True

  logging.debug('Cannot find tag \"{}\" in {}/{} '.format(tag_arg, resource['resourceType'], resource['id']))
  return False

def main():
  logging.info('Load FHIR Bundle from file')
  with open(args.bundle) as json_file:
    bundle = json.load(json_file)
  
  logging.info('Read FHIR Bundle containing {} of {} entries'.format(len(bundle['entry']), bundle['total']))
  logging.info('Extract FHIR QuestionnaireResponse entries from FHIR Bundle')
  
  answers = []
  subjects = set()
  answer_codes = load_answer_codes(args.codes)
  
  for entry in bundle['entry']:
    resource = entry['resource']
  
    if has_tag(resource, args.tag):
      answer = {
        'id': resource['subject']['reference'],
        'questionnaire': resource['questionnaire'],
        'date': resource['authored'],
        'items': {}
      }
      subjects.add(answer['id'])
  
      logging.debug('Process FHIR QuestionnaireResponse resource {} for questionnaire {}'.format(entry['fullUrl'], resource['questionnaire']))
      if len(resource['item']) == 0:
        logging.warning('Skip processing of resource {} because no item available'.format(entry['fullUrl']))
      else:
        answer['items'] = extract_answers(
          resource['item'], 
          resource['questionnaire'],
          answer_codes
        )
        answers.append(answer)
  
  logging.debug(answers)
  logging.info('Flatten the structure of FHIR QuestionnaireResponse entries')
  rows = []
  source_date_format = '%Y-%m-%dT%H:%M:%S.%fZ'
  target_date_format = '%d.%m.%Y'
  
  for subject in subjects:
    row = {'id': subject}
  
    for answer in answers:
      # TODO: Fix string static replacement
      prefix = answer['questionnaire'].replace('http://example.com/Questionnaire/', '')
  
      if answer['id'] == subject:
        col_date = '{}|{}'.format(prefix, 'date')
        source_date = datetime.strptime(answer['date'], source_date_format)
        target_date = source_date.strftime(target_date_format)
        row[col_date] = target_date
  
        for key in answer['items'].keys():
          row[key] = answer['items'][key]
      
    rows.append(row)
  
  logging.debug(rows)
  logging.info('Extract unique column headers')
  headers = {}
  
  for row in rows:
    for key in row.keys():
      headers[key] = None
  
  logging.debug(headers)
  logging.info('Write CSV data to file')
  with open(args.output, 'w') as csv_file:
    writer = csv.DictWriter(
      csv_file, 
      fieldnames = headers.keys(), 
      dialect = args.dialect
    )
    writer.writeheader()
    writer.writerows(rows)

if __name__ == '__main__':
  main()