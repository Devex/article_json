#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Simple script to read a JSON document and export it to plain text.
#
# Usage:
#
#   ./bin/article_json_export_plain_text.rb < my_document.json
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require_relative '../lib/article_json'
puts ArticleJSON::Article.from_json(ARGF.read).to_plain_text
