# Changelog

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
