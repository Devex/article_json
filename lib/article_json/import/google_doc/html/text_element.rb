module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class TextElement
          # @param [Nokogiri::XML::Node] text_node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(text_node:, css_analyzer:)
            @text_node = text_node
            @css_analyzer = css_analyzer
          end

          # The content of the text node, w/o any markup
          # @return [String]
          def content
            @text_node.inner_text
          end

          # Check if the text node is styled as bold
          # @return [Boolean]
          def bold?
            @text_node.name == 'span' &&
              @text_node.has_attribute?('class') &&
              @css_analyzer.bold?(@text_node.attribute('class').value)
          end

          # Check if the text node is styled as italic
          # @return [Boolean]
          def italic?
            @text_node.name == 'span' &&
              @text_node.has_attribute?('class') &&
              @css_analyzer.italic?(@text_node.attribute('class').value)
          end

          # A possible link target for the text, otherwise `nil`
          # Google redirects (basically all links in a google doc html export)
          # are stripped.
          # @return [String]
          def href
            if @text_node.name == 'span' &&
                @text_node.first_element_child&.name == 'a' &&
                @text_node.first_element_child&.has_attribute?('href')
              strip_google_redirect(
                @text_node.first_element_child.attribute('href').value
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
            # @param [Nokogiri::XML::Node] text_node
            # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
            def extract(text_node:, css_analyzer:)
              text_node.children.map do |child_node|
                new(text_node: child_node, css_analyzer: css_analyzer)
              end
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
