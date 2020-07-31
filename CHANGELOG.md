# Changelog
## 0.3.8 - 2020/7/31
- **Improvements:**
- Add a script to update oembed stubs fixtures.
- Support for `alt` attribute in images.

- **Fix:** Fix a bug when using the `[image-link-to: ]` tag.

## 0.3.7 - 2019/8/21
- **Fix:** Only use https for soundcloud oembed api

## 0.3.6 - 2019/8/6
- **Improvement** Add tags support in text_box element.

## 0.3.5 - 2018/12/12
- **Improvements** to import and export image links from Google Docs
- Import image `href` from caption text using a custom tag
- Export the image element href attribute as a link

## 0.3.4 - 2018/5/10
- **Fix:** Only include slug from the soundcloud URL in google doc parser

## 0.3.3 - 2018/4/12
- Support embedding SoundCloud

## 0.3.2 - 2017/12/06
- Another **fix** to prevent `nil` elements when placing additional elements on articles that end with empty paragraphs

## 0.3.1 - 2017/11/29
- **Fix:** prevent `nil` elements when placing additional element on empty articles

## 0.3.0 - 2017/11/21
In this third bigger release we **added support**:
- For exporting articles in the Facebook Instant Article format
- For exporting articles in a plain text format
- To all exporters for `caption` elements that are an empty array
- For `[no-caption]` text in _Google Documents_ below elements (like images or embed URLs), this now returns empty caption for element

**Improvements** were done regarding additional element placement:
- Rework algorithm to place additional elements to better support placing a single element
- Improve behavior of multiple calls to `Article#place_additional_elements`

One potentially **breaking change** was added:
- Remove deprecated `#register_html_element_exporter`, use `#register_element_exporters` instead

**Fixes**:
- Fix AMP export of Twitter tweets

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
