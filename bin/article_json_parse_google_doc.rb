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

require 'bundler/setup'
require_relative '../lib/article_json'
puts ArticleJSON::Article.from_google_doc_html((ARGF.read)).to_json
