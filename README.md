# article_json
JSON Format for News Articles & Ruby Gem.

## Status
[![Gem Version](https://badge.fury.io/rb/article_json.svg)](https://badge.fury.io/rb/article_json)
[![Build Status](https://travis-ci.org/Devex/article_json.svg)](https://travis-ci.org/Devex/article_json)
[![Code Climate](https://codeclimate.com/github/Devex/article_json/badges/gpa.svg)](https://codeclimate.com/github/Devex/article_json)
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

# export article as JSON
puts article.to_json
```

### CLI
To load, parse and html-export the latest version of the reference document,
run the following:

```
$ export DOC_ID=1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8
$ ./bin/article_json_export_google_doc.rb $DOC_ID \
    | ./bin/article_json_parse_google_doc.rb \
    | ./bin/article_json_export_html.rb
```

## Format
A full example of the format can be found in the test fixtures:
[Parsed Reference Document](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_parsed.json)

## Import
### Google Document Parser
This [Reference Document](https://docs.google.com/document/d/1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8/edit?usp=sharing)
lists contains all supported formatting along with some descriptions.

## Export
### HTML
The HTML exporter generates a HTML string for a list of elements. An example of
the HTML export for the parsed reference document can be found 
[here](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_exported.html).

## Contributing
- Fork this repository
- Implement your feature or fix including Tests
- Update the [change log](CHANGELOG.md)
- Commit your changes with a meaningful commit message
- Create a pull request

Thank you!

See the 
[list of contributors](https://github.com/Devex/article_json/contributors).

### Tests
For the whole test suite, run `bundle exec rspec`.

For individual tests, run `bundle exec rspec spec/article_json/version_spec.rb`. 

## License
MIT License, see the [license file](LICENSE).
