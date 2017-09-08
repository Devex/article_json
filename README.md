# article_json
JSON Format for News Articles & Ruby Gem.

## Status
[![Build Status](https://travis-ci.org/Devex/article_json.svg)](https://travis-ci.org/Devex/article_json)
[![Code Climate](https://codeclimate.com/github/Devex/article_json/badges/gpa.svg)](https://codeclimate.com/github/Devex/article_json)
[![Coverage Status](https://coveralls.io/repos/github/Devex/article_json/badge.svg?branch=master)](https://coveralls.io/github/Devex/article_json?branch=master)

## Usage
First, install the gem with `gem install article_json` or add it to your Gemfile
via `gem 'article_json'`.

### Ruby
_TBD_

### CLI
To load, parse, and pretty print the latest version of the reference document,
run the following:

```
$ export DOC_ID=1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8
$ ./bin/article_json_export_google_doc.rb $DOC_ID \
    | ./bin/article_json_parse_google_doc.rb \
    | jq .
```
Note: you either need to install the useful `jq` tool or omit the last line...

## Format
A full example of the format can be found in the test fixtures:
[Parsed Reference Document](https://github.com/Devex/article_json/blob/master/spec/fixtures/reference_document_parsed.json)

## Google Document Parser
This [Reference Document](https://docs.google.com/document/d/1E4lncZE2jDkbE34eDyYQmXKA9O26BHUiwguz4S9qyE8/edit?usp=sharing)
lists contains all supported formattings along with some descriptions.

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
