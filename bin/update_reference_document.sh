#!/usr/bin/env sh

# set google doc id
DOC_ID="1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8"

# set file locations
SOURCE_HTML_FILE="spec/fixtures/reference_document.html"
JSON_FILE="spec/fixtures/reference_document_parsed.json"
HTML_EXPORT_FILE="spec/fixtures/reference_document_exported.html"
AMP_EXPORT_FILE="spec/fixtures/reference_document_exported.amp.html"
FACEBOOK_EXPORT_FILE="spec/fixtures/reference_document_exported.facebook.html"
PLAIN_TEXT_EXPORT_FILE="spec/fixtures/reference_document_exported.txt"

# export the google doc to HTML
./bin/article_json_export_google_doc.rb ${DOC_ID} > ${SOURCE_HTML_FILE}

# convert the google doc html export to JSON
./bin/article_json_parse_google_doc.rb < ${SOURCE_HTML_FILE} | jq . > ${JSON_FILE}

# convert the JSON export to HTML
./bin/article_json_export_html.rb < ${JSON_FILE} > ${HTML_EXPORT_FILE}

# convert the JSON export to AMP
./bin/article_json_export_amp.rb < ${JSON_FILE} > ${AMP_EXPORT_FILE}

# convert the JSON export to Facebook Instant Article
./bin/article_json_export_facebook.rb < ${JSON_FILE} > ${FACEBOOK_EXPORT_FILE}

# convert the JSON export to plain text
./bin/article_json_export_plain_text.rb < ${JSON_FILE} > ${PLAIN_TEXT_EXPORT_FILE}
