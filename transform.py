#!/usr/bin/env python3
import argparse
import csv
import json
import logging
from pathlib import Path

arg_parser = argparse.ArgumentParser(description = 'Transform FHIR Bundle with QuestionnaireResponse entries to CSV')
arg_parser.add_argument('-a', '--codes', help='Path to FHIR ConceptMap file with answer codes', type=Path, default=None)
arg_parser.add_argument('-d', '--dialect', help='Dialect used to format CSV', type=str, default='excel', choices=['excel', 'excel-tab', 'unix'])
arg_parser.add_argument('-l', '--logfile', help='Path to log file', type=Path, default=Path('./result.log'))
arg_parser.add_argument('-o', '--output', help='Path to CSV output file', type=Path, default=Path('./result.csv'))
arg_parser.add_argument('-t', '--tag', help='Tag for survey time (QuestionnaireResponse.meta.tag)', type=str, default=None)
arg_parser.add_argument('-v', '--verbosity', help='Verbosity of output', type=str, default='INFO', choices=['INFO', 'WARNING', 'DEBUG'])
arg_parser.add_argument('bundle', help='Path to FHIR Bundle input file', type=Path)
args = arg_parser.parse_args()

logging.basicConfig(
  filename=args.logfile, 
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
      code_map[source] = {code_from: code_to}

  return code_map

def to_str(dic):
  res = ''

  for val in dic.values():
    if type(val) is dict:
      if ('system' in val) and ('code' in val):
        res = '{}|{}'.format(val['system'], val['code'])
      else:
        return to_str(val)
    else:
      if not res:
        res = val
      else:
        res = '{}|{}'.format(res, val)

  return res

def extract_answers(items, questionnaire, answer_codes):
  answers = {}

  for item in items:
    variable = item['linkId']

    if 'answer' in item:
      for answer in item['answer']:
        answer = to_str(answer)

        if answer_codes and (questionnaire in answer_codes) and (answer in answer_codes[questionnaire]):
          answers.update({variable: answer_codes[questionnaire][answer]})
        else:
          answers.update({variable: answer})
    
    if 'item' in item:
        logging.info('Process nested items for item {}'.format(item['linkId']))
        answers.update(extract_answers(item['item'], questionnaire, answer_codes))

  return answers

logging.info('Load FHIR Bundle from file')
with open(args.bundle) as json_file:
  bundle = json.load(json_file)

logging.info('Read FHIR Bundle containing {} of {} entries'.format(len(bundle['entry']), bundle['total']))
logging.debug(bundle)
logging.info('Extract FHIR QuestionnaireResponse entries from FHIR Bundle')

answers = []
subjects = set()
answer_codes = load_answer_codes(args.codes)

for entry in bundle['entry']:
  resource = entry['resource']
  answer = {
    'id': resource['subject']['reference'],
    'questionnaire': resource['questionnaire'],
    'date': resource['authored'],
    'items': {}
  }
  subjects.add(answer['id'])

  logging.debug('Process FHIR QuestionnaireResponse resource {}'.format(entry['fullUrl']))
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

for subject in subjects:
  row = {'id': subject}

  for answer in answers:
    prefix = answer['questionnaire']

    if answer['id'] == subject:
      col_date = '{}|{}'.format(prefix, 'date')
      row[col_date] = answer['date']

      for key in answer['items'].keys():
        col_item = '{}|{}'.format(prefix, key)
        row[col_item] = answer['items'][key]
    
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