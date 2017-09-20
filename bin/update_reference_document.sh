#!/usr/bin/env sh

# set google doc id
DOC_ID="1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8"

# set file locations
SOURCE_HTML_FILE="spec/fixtures/reference_document.html"
JSON_FILE="spec/fixtures/reference_document_parsed.json"
HTML_EXPORT_FILE="spec/fixtures/reference_document_exported.html"

# export the google doc to HTML
./bin/article_json_export_google_doc.rb ${DOC_ID} > ${SOURCE_HTML_FILE}

# convert the google doc html export to JSON
./bin/article_json_parse_google_doc.rb < ${SOURCE_HTML_FILE} | jq . > ${JSON_FILE}

# convert the JSON export to HTML
./bin/article_json_export_html.rb < ${JSON_FILE} > ${HTML_EXPORT_FILE}
