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

require 'net/http'
require 'uri'
require_relative '../lib/article_json'

doc_id = "1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8"
url = "https://docs.google.com/feeds/download/documents/export/Export?id=#{doc_id}&exportFormat=html"
expected_document = JSON.parse(File.read('spec/fixtures/reference_document_parsed.json'))

exported_doc =  Net::HTTP.get(URI.parse(url))

document = JSON.parse(ArticleJSON::Article.from_google_doc_html(exported_doc).to_json) 

if document != expected_document
  raise 'Google doc export doesn\'t work as espected'
end

puts 'Google doc export worked as expected'
