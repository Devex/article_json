# article_json
The `article_json` gem is a Ruby library designed to simplify the conversion and manipulation of structured articles in various formats, allowing easy importing, manipulation and export of content across different platforms and environments.

It takes an article from a Google Doc and creates a JSON version of it.

From there it can export the article:
- as HTML
- as AMP
- as Apple News Format (ANF)
- as Facebook Instant Article HTML
- as plain text
- as JSON

It also provides functionalities to parse content from Google Document HTML exports and initialize articles from JSON strings or already parsed JSON.

---

## Status
[![Gem Version](https://badge.fury.io/rb/article_json.svg)](https://badge.fury.io/rb/article_json)
[![Check Google Doc](https://github.com/Devex/article_json/workflows/Check%20Google%20Doc/badge.svg)](https://github.com/Devex/article_json/actions/workflows/check-google-doc.yml)
[![RSpec](https://github.com/Devex/article_json/workflows/rspec/badge.svg)](https://github.com/Devex/article_json/actions/workflows/rspec.yml)
[![Code Climate](https://codeclimate.com/github/Devex/article_json/badges/gpa.svg)](https://codeclimate.com/github/Devex/article_json?event=push)
[![Coverage Status](https://coveralls.io/repos/github/Devex/article_json/badge.svg?branch=master)](https://coveralls.io/github/Devex/article_json?branch=master)

## Usage
First, install the gem with `gem install article_json` or add it to your Gemfile
via `gem 'article_json'`.

### Ruby
```ruby
require 'article_json'

# parse the HTML export of a Google Document
article = ArticleJSON::Article.from_google_doc_html(google_doc_html)

# initialize article-json format from storage (JSON string)
article = ArticleJSON::Article.from_json(json_string)

# initialize article-json format from storage (already parsed JSON)
article = ArticleJSON::Article.from_hash(parsed_json)

# export article as HTML
puts article.to_html

# export article as AMP
puts article.to_amp
# get javascript libraries needed for the AMP article
puts article.amp_exporter.amp_libraries

# export article as Apple News Format (ANF)
puts article.to_apple_news

# export article as Facebook Instant Article HTML
puts article.to_facebook_instant_article

# export article as plain text
puts article.to_plain_text

# export article as JSON
puts article.to_json
```

### CLI
To load, parse and export the latest (amp/ apple news/ facebook/ html) version of the reference document, run the following:

```bash
$ export DOC_ID=1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8
$ ./bin/article_json_export_google_doc.rb $DOC_ID \
    | ./bin/article_json_parse_google_doc.rb \
    | ./bin/article_json_export_html.rb
    ## OR
    # | ./bin/article_json_export_amp.rb
    # | ./bin/article_json_export_apple_news.rb
    # | ./bin/article_json_export_facebook.rb
    # | ./bin/article_json_export_plain_text.rb
```

Alternatively, you can concatenate your command line commands, like so:
```bash
$ ./bin/article_json_export_google_doc.rb $DOC_ID > test_ref_doc.html
$ cat test_ref_doc.html | bin/article_json_parse_google_doc.rb > \
    test_ref_doc_parsed_apple.json
$ cat test_ref_doc_parsed_apple.json | bin/article_json_export_apple_news.rb > \
    test_ref_doc_exported_apple.json
```

You can also update _all_ the different exported versions of the reference document _(amp, apple_news, facebook, google_doc, html and plain_text)_ by running the following command:

```
$ ./bin/update_reference_document.sh
```

When running the tests, we use some fixtures to mock the responses for oembed requests, but these may change over time.

To update them, run:

```
$ ./bin/update_oembed_request-stubs.sh
```

### Configuration
Some configuration options allow a more tailored usage of the `article_json` gem.

The following code snippet gives an example for every available setting:

```ruby
ArticleJSON.configure do |config|
  # set a custom user agent used for o-embed API calls
  config.oembed_user_agent = 'devex oembed (+https://www.devex.com/)'

  # Register additional html exporters, just make sure that it complies with the
  # interface of other element exporter classes (extend Base, implement #export)
  config.register_element_exporters(
    :html,
    advertisement: ArticleJSON::Export::HTML::Elements::Advertisement
  )

  # You can also overwrite existing exporters:
  config.register_element_exporters(
    :html,
    image: ArticleJSON::Export::HTML::Elements::ScaledImage
  )

  # And you can define multiple custom exporters:
  config.register_element_exporters(
    :html,
    advertisement: ArticleJSON::Export::HTML::Elements::Advertisement,
    image: ArticleJSON::Export::HTML::Elements::ScaledImage
  )

  # It works the same way for custom AMP, FacebookInstantArticle, or PlainText
  # exporters:
  config.register_element_exporters(
    :amp, # Or change this for `:facebook_instant_article` or `:plain_text`
    image: ArticleJSON::Export::AMP::Elements::ScaledImage
  )
end
```

### Facebook Oembed
Facebook deprecated its public endpoints for embeddable Facebook content in 2020 (See https://developers.facebook.com/docs/plugins/oembed-legacy for more info).

You now need to use a Facebook token to access the new oembed endpoints. You can configure the gem to use this token so:

``` ruby
ArticleJSON.configure do |config|
  # 'token' being the combination of the app-id and the access token joined
  # with the pipe symbol (`|`)
  config.facebook_token = 'token'
end
```

Find more info about the access token [here](https://developers.facebook.com/docs/plugins/oembed#access-tokens).

## Format
A [full example of the format](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_parsed.json) can be found in the test fixtures.

## Import
### Google Document Parser
This [reference document](https://docs.google.com/document/d/1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8/editusp=sharing) contains all the supported formatting along with some descriptions.

## Add custom elements
Sometimes you might want to place additional elements into the article, like e.g. advertisements. `article_json` supports this via `article.place_additional_elements`, which accepts an array of elements that you can define in your code.

Each element that is added this way will directly get placed in between paragraphs of the article. The method ensures that an additional element is never added before or after any node other than paragraphs (e.g. an image). The elements are added in the order you pass them into the method.

If the article does not have enough space to place all the provided elements, they will be placed after the last
element in the article.

You can pass any type of element into this method.

If the objects you pass in are instances of elements defined within this gem (e.g. `ArticleJSON::Elements::Image`), you won't have to do anything else to render them.

If you pass in an instance of a custom class (e.g. `MyAdvertisement`), make sure to register an exporter for this type (check the _Configuration_ section for more details).

Example using only existing elements:
```ruby
# Create your article instance as you normally do
article = ArticleJSON::Article.from_hash(parsed_json)

# Within your code, create additional elements you would like to add
image_advertisement =
  ArticleJSON::Elements::Image.new(source_url: 'https://robohash.org/great-ad',
                                   caption: ArticleJSON::Elements::Text.new(
                                    content: 'Buy more robots!',
                                    href: '/robot-sale'
                                   ))
text_box_similar_articles =
  ArticleJSON::Elements::TextBox.new(content: [
    ArticleJSON::Elements::Heading.new(level: 3, content: 'Read more...'),
    ArticleJSON::Elements::List.new(content: [
      ArticleJSON::Elements::Paragraph(content: [
        ArticleJSON::Elements::Text.new(content: 'Very similar article',
                                        href: '/news/123'),
      ]),
      ArticleJSON::Elements::Paragraph(content: [
        ArticleJSON::Elements::Text.new(content: 'Great article!',
                                        href: '/news/42'),
      ]),
    ]),
  ])

# Add these elements to the article
article.place_additional_elements([image_advertisement,
                                   text_box_similar_articles])

# Export the article to the different formats as you would normally do
article.to_html # this will now include the custom elements
```

Example with custom advertisement elements:
```ruby
# Define your custom element class
class MyAdvertisement
  attr_reader :url

  def initialize(url:)
    @url = url
  end

  def type
    :my_advertisement
  end
end

# Define an exporter for your class, we only use HTML in this example but this
# would work similarly for AMP or other formats
class MyAdvertisementExporter <
  ArticleJSON::Export::HTML::Elements::Base

  # Needs to implement the `#export` method
  def export
    create_element(:iframe, src: @element.url)
  end
end

# Register your custom exporter for your element type
config.register_element_exporters(
  :html,
  my_advertisement: MyAdvertisementExporter
)

# Create the elements you want to add
ad_1 = MyAdvertisement.new(url: '/my_first_ad')
ad_2 = MyAdvertisement.new(url: '/my_second_ad')
ad_3 = MyAdvertisement.new(url: '/my_last_ad')

# Add them to the article
article.place_additional_elements([ad_1, ad_2, ad_3])

# And again, export the article as you would normally do it
article.to_html
```

## Export
### HTML
The HTML exporter generates an HTML string for a list of elements. An example of the HTML export for the parsed reference document can be found [here](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_exported.html).

### AMP
The AMP exporter generates an AMP HTML representation of the elements.

AMP uses [custom HTML tags](https://www.ampproject.org/docs/reference/components), some of which require additional Javascript libraries.

If you have an `article` (see code example in _Usage_ section), you can get a list of the custom tags required by this article by calling `article.amp_exporter.custom_element_tags` and calling `article.amp_exporter.amp_libraries` gives a list of `<script>` tags that can directly be included on your page to render the AMP article.

An example of the AMP HTML export for the parsed reference document can be found [here](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_exported.amp.html).

### Facebook Instant Articles
The `FacebookInstantArticle` exporter generates a custom HTML string for a list of elements. An example of the Facebook Instant Article export for the parsed reference document can be found [here](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_exported.html).

To learn more about the Facebook Instant Article HTML format see have a look at the [Facebook Developer Documentation](https://developers.facebook.com/docs/instant-articles/guides/format-overview).

### Plain Text
As the name suggests, this exporter generates a plain text version of the article. Rich text elements like images, embeds or even text boxes are not being rendered.

The reference document rendered as plain text can be found [here](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_exported.txt).

Usage:
```ruby
# Create your article instance as you normally do
article = ArticleJSON::Article.from_hash(parsed_json)

# Then simply call `#to_plain_text` on it
article.to_plain_text
```

## Contributing
- Fork this repository
- Implement your feature or fix including tests
- Update the [change log](CHANGELOG.md)
- Commit your changes with a meaningful commit message
- Create a pull request

Thank you!

See the
[list of contributors](https://github.com/Devex/article_json/contributors).

## Tests
For the whole test suite, run `bundle exec rspec`.

For individual tests, run `bundle exec rspec spec/article_json/version_spec.rb`.

## License
MIT License, see the [license file](LICENSE).
