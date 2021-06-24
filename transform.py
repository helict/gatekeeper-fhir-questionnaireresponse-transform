#!/usr/bin/env python3
import json
import csv
import logging

filenames = {
  'source': 'example-1.json',
  'target': 'example.csv',
  'log': 'transform.log',
  'answer-codes': 'answer-codes-cm.json'
}

logging.basicConfig(
  filename=filenames['log'], 
  encoding='utf-8', 
  level=logging.DEBUG,
  format='%(asctime)s %(levelname)-8s %(message)s',
  datefmt='%Y-%m-%d %H:%M:%S'
)

def load_answer_codes():
  code_map = {}

  logging.info('Load FHIR ConceptMap answer codes from file')
  with open(filenames['answer-codes']) as json_file:
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

        if (questionnaire in answer_codes) and (answer in answer_codes[questionnaire]):
          answers.update({variable: answer_codes[questionnaire][answer]})
        else:
          answers.update({variable: answer})
    
    if 'item' in item:
        logging.info('Process nested items for item {}'.format(item['linkId']))
        answers.update(extract_answers(item['item'], questionnaire, answer_codes))

  return answers

logging.info('Load FHIR Bundle from file')
with open(filenames['source']) as json_file:
  bundle = json.load(json_file)

logging.info('Read FHIR Bundle containing {} of {} entries'.format(len(bundle['entry']), bundle['total']))
logging.debug(bundle)
logging.info('Extract FHIR QuestionnaireResponse entries from FHIR Bundle')

answers = []
subjects = set()
answer_codes = load_answer_codes()

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
with open(filenames['target'], 'w') as csv_file:
  writer = csv.DictWriter(
    csv_file, 
    fieldnames = headers.keys(), 
    dialect = 'excel-tab'
  )
  writer.writeheader()
  writer.writerows(rows)