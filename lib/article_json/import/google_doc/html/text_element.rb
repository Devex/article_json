module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class TextElement
          # @param [Nokogiri::HTML::Node] node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, css_analyzer:)
            @node = node
            @css_analyzer = css_analyzer
          end

          # The content of the text node, w/o any markup
          # @return [String]
          def content
            @node.inner_text
          end

          # Check if the text node is styled as bold
          # @return [Boolean]
          def bold?
            @node.name == 'span' &&
              @node.has_attribute?('class') &&
              @css_analyzer.bold?(@node.attribute('class').value)
          end

          # Check if the text node is styled as italic
          # @return [Boolean]
          def italic?
            @node.name == 'span' &&
              @node.has_attribute?('class') &&
              @css_analyzer.italic?(@node.attribute('class').value)
          end

          # A possible link target for the text, otherwise `nil`
          # Google redirects (basically all links in a google doc html export)
          # are stripped.
          # @return [String]
          def href
            if @node.name == 'span' &&
                @node.first_element_child&.name == 'a' &&
                @node.first_element_child&.has_attribute?('href')
              strip_google_redirect(
                @node.first_element_child.attribute('href').value
              )
            end
          end

          # Hash representation of this text node
          # @return [Hash]
          def to_h
            {
              type: :text,
              content: content,
              bold: bold?,
              italic: italic?,
              href: href,
            }
          end

          class << self
            # Extract multiple text nodes from a wrapping node
            # The wrapping node is usually a paragraph or caption
            # @param [Nokogiri::HTML::Node] node
            # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
            def extract(node:, css_analyzer:)
              node.children.map do |child_node|
                next if NodeAnalyzer.new(child_node).empty?
                new(node: child_node, css_analyzer: css_analyzer)
              end.compact
            end
          end

          private

          # @param [String] url
          # @return [String]
          def strip_google_redirect(url)
            uri = URI(url)
            if uri.host && uri.host.match(/google\.com/) && uri.path == '/url'
              params = CGI.parse(uri.query)
              return params['q'].first if params['q'] && params['q'].any?
            end
            url
          end
        end
      end
    end
  end
end
