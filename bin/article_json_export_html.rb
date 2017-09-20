#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Simple script to read a JSON document and export it to HTML.
#
# Usage:
#
#   ./bin/article_json_export_html.rb < my_document.json
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require_relative '../lib/article_json'
puts ArticleJSON::Article.from_json(ARGF.read).to_html
