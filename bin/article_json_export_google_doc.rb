#!/usr/bin/env ruby

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Simple script to load an HTML export for a Google document by ID.
#
# Usage:
#
#   ./bin/article_json_export_google_doc.rb $GOOGLE_DOC_ID
#
# Note: The document has to be publicly accessible via link. If the docuement is
#       private, you can use the URL schema below and open it in a browser while
#       being signed in to Google Drive.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require 'net/http'
require 'uri'

doc_id = ARGV.first
url = "https://docs.google.com/feeds/download/documents/export/Export?id=#{doc_id}&exportFormat=html"
puts Net::HTTP.get(URI.parse(url))
