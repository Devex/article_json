#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Simple script to read a JSON document and export it to Apple News.
#
# Usage:
#
#   ./bin/article_json_export_apple_news.rb < my_document.json
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require 'bundler/setup'
require_relative '../lib/article_json'
puts ArticleJSON::Article.from_json(ARGF.read).to_apple_news
