#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Script to check that google doc export works as expected.
#
# Usage:
#
#   ./bin/check_google_doc_export.rb
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require 'bundler/setup'
require 'net/http'
require 'uri'
require_relative '../lib/article_json'

doc_id = '1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8'
url =
  "https://docs.google.com/feeds/download/documents/export/Export?id=#{doc_id}&exportFormat=html"
parsed_exported_doc = JSON.parse(
  ArticleJSON::Article
    .from_google_doc_html(Net::HTTP.get(URI.parse(url)))
    .to_json
)
parsed_expected_doc = JSON.parse(File.read('spec/fixtures/reference_document_parsed.json'))

# `source_url` (for hosted images) is dynamic, so we need to remove it from the comparison`
def nullify_source_url(hash)
  hash['content'].each { |element| element['source_url'] = nil if element['source_url'] }
  hash
end

parsed_exported_doc = nullify_source_url(parsed_exported_doc)
parsed_expected_doc = nullify_source_url(parsed_expected_doc)

if parsed_exported_doc != parsed_expected_doc
  raise StandardError, "Google doc export doesn't work as expected"
end

puts 'Google doc export worked as expected'
