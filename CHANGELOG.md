# Changelog

## WIP
- Start work on Facebook Instant Article exporter
- Add support to exporters for `caption` elements that are an empty array
- GDoc Importer: Support `[no-caption]` text, returns empty caption for element
- Fix AMP export of Twitter tweets
- Add a plain text exporter
- Improve behavior of multiple calls to `Article#place_additional_elements`
- Remove deprecated `#register_html_element_exporter`, use `#register_element_exporters` instead

## 0.2.1 - 2017/11/08
**Fix**: Handle non-successful OEmbed responses by rendering message

## 0.2.0 - 2017/11/03
In this second release we **added support** to:
- Export AMP along with required libraries for AMP rendering
- Configure custom HTML and AMP element exporters
- Resolve oembed elements in HTML export

One potentially **breaking change** was added:
- Export quotes as `<div>` instead of `<aside>`

**Fixes**:
- Support Vimeo videos with old flash player URLs
- Make Google Parser more fault tolerant
- Respect linebreaks when importing Google Docs
- Export linebreaks in JSON to `<br>` tags in HTML / AMP

## 0.1.0 - 2017/09/20
This is the very first release, with the following functionality:
- article-json format that supports several basic elements; like headings, 
  paragraphs, images or lists
- Resolving of embedded elements like videos or tweets via OEmbed standard
- Conversion from and to JSON (or ruby hashes)
- Parsing of HTML exports from Google documents
- Export into plain HTML
