#!/usr/bin/env sh

jq -r '.group[] * .group[]' ${PWD}/*.json | \
jq -s '{ resourceType: "ConceptMap", group: . }' > ${PWD}/../answer_codes.json

exit $?
