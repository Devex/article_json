require_relative 'lib/article_json/version'

Gem::Specification.new do |s|
  s.name = 'article_json'
  s.version = ArticleJSON::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = %w(@dsager)
  s.email = 'info@devex.com'
  s.homepage = 'https://github.com/Devex/article_json'
  s.license = 'MIT'

  s.summary = 'JSON Format for News Articles & Ruby Gem'
  s.description = <<-txt
`article_json` is a format definition for news articles and a ruby gem that
offers conversions from and to different formats:
- Parser for Google Doc HTML exports
- Converter to simple HTML format
- Converter to AMP format
txt

  s.files = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
  s.test_files = s.files.grep(%r{^(spec)/})

  s.add_development_dependency 'bundler', '~> 1.15'
end
