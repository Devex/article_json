require_relative 'lib/article_json/version'

Gem::Specification.new do |s|
  s.name = 'article_json'
  s.version = ArticleJSON::VERSION
  s.platform = Gem::Platform::RUBY

  s.authors = ['Daniel Sager', 'Manu Campos', 'Nicolas Fricke']
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

  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'nokogiri', '~> 1.8'
  s.add_runtime_dependency 'css_parser', '~> 1.5'

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'webmock', '~> 3.0'
  s.add_development_dependency 'coveralls', '~> 0.8'
end
