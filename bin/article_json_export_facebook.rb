#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Simple script to read a JSON document and export it to Facebook Instant
# Article.
#
# Usage:
#
#   ./bin/article_json_export_facebook.rb < my_document.json
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require_relative '../lib/article_json'
puts ArticleJSON::Article.from_json(ARGF.read).to_facebook_instant_article
