#!/usr/bin/env python3
import json
import csv
import logging

filenames = {
  'source': 'example.json',
  'target': 'example.csv',
  'log': 'transform.log'
}

logging.basicConfig(
  filename=filenames['log'], 
  encoding='utf-8', 
  level=logging.DEBUG,
  format='%(asctime)s %(levelname)-8s %(message)s',
  datefmt='%Y-%m-%d %H:%M:%S'
)

def to_str(dic):
  res = ""

  for val in dic.values():
    if type(val) is dict:
      if ('system' in val) and ('code' in val):
        r = "{}|{}".format(val['system'], val['code'])
      else:
        return to_str(val)
    else:
      if not res:
        res = val
      else:
        res = "{}|{}".format(res, val)

  return res

def extract_answers(items):
  answers = {}

  for _item in items:
    _variable = _item['linkId']

    if 'answer' in _item:
      for _answer in _item['answer']:
        answers.update({
          _variable: to_str(_answer)
        })
    
    if 'item' in _item:
        logging.info('Process nested items for item {}'.format(_item['linkId']))
        answers.update(extract_answers(_item['item']))

  return answers


logging.info('Load FHIR Bundle from file or stream')
with open(filenames['source']) as json_file:
  bundle = json.load(json_file)

logging.info('Read FHIR Bundle containing {} of {} entries'.format(len(bundle['entry']), bundle['total']))
logging.debug(bundle)
logging.info('Extract FHIR QuestionnaireResponse entries from FHIR Bundle')

answers = []
subjects = set()

for entry in bundle['entry']:
  _resource = entry['resource']
  _authored = _resource['authored']
  _questionnaire = _resource['questionnaire']
  _subject = _resource['subject']['reference']

  subjects.add(_subject)

  answer = {
    'id': _subject,
    'questionnaire': _questionnaire,
    'date': _authored,
    'items': {}
  }

  logging.debug('Process FHIR QuestionnaireResponse resource {}'.format(entry['fullUrl']))
  if len(_resource['item']) == 0:
    logging.warning('Skip processing of resource {} because no item available'.format(entry['fullUrl']))
  else:
    answer['items'] = extract_answers(_resource['item'])
    answers.append(answer)

logging.debug(answers)
logging.info('Flatten the structure of FHIR QuestionnaireResponse entries')
rows = []

for _subject in subjects:
  _row = {'id': _subject}

  for _answer in answers:
    _prefix = _answer['questionnaire']

    if _answer['id'] == _subject:
      _col_date = "{}|{}".format(_prefix, "date")
      _row[_col_date] = _answer['date']

      for _key in _answer['items'].keys():
        _col_item = "{}|{}".format(_prefix, _key)
        _row[_col_item] = _answer['items'][_key]
    
  rows.append(_row)

logging.debug(rows)
logging.info('Extract unique column headers')
headers = {}

for _row in rows:
  for _key in _row.keys():
    headers[_key] = None

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