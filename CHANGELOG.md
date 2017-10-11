# Changelog

## ? - WIP
- Configurable HTML element exporters
- Resolve oembed elements in HTML export
- Export quotes as `<div>` instead of `<aside>`
- Make Google Parser more fault tolerant
- Support Vimeo videos with old flash player URLs
- Export AMP
- Return required libraries for AMP rendering

## 0.1.0 - 2017/09/20
This is the very first release, with the following functionality:
- article-json format that supports several basic elements; like headings, 
  paragraphs, images or lists
- Resolving of embedded elements like videos or tweets via OEmbed standard
- Conversion from and to JSON (or ruby hashes)
- Parsing of HTML exports from Google documents
- Export into plain HTML
