# Merge FHIR bundle entries with this filter using command:
# jq -s -f merge-bundles.jq bundle1.json bundle2.json
.[0].entry + .[1].entry | { 
  "resourceType": "Bundle",
  "total": . | length | tostring,
  "entry": .
}