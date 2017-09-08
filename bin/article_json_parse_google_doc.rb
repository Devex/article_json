#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Simple script to read a Google Doc HTML export from STDIN and parse it.
#
# Usage:
#
#   ./bin/article_json_parse_google_doc.rb < my_document.html
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require_relative '../lib/article_json'

parser = ArticleJSON::Import::GoogleDoc::HTML::Parser.new(ARGF.read)
puts parser.parsed_content.map(&:to_h).to_json
