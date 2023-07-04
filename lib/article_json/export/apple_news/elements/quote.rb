module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Quote < Base
          include ArticleJSON::Export::Common::HTML::Elements::Base
          include ArticleJSON::Export::Common::HTML::Elements::Text

          def export
            [quote, author]
          end

          private

          # Quote
          # @return [Hash]
          def quote
            {
              role: 'pullquote',
              text: quote_text,
              format: 'html',
              layout: 'pullquoteLayout',
              textStyle: 'pullquoteStyle',
            }
          end

          # Author
          # @return [Hash]
          def author
            {
              role: 'author',
              text: author_text,
              format: 'html',
              layout: 'pullquoteAttributeLayout',
              textStyle: 'quoteAttributeStyle',
            }
          end

          def text_exporter
            self.class.exporter_by_type(:text)
          end

          # Quote Text
          # @return [String]
          def quote_text
            element = @element.content.first&.content.first
            text_exporter.new(element).export
          end

          # Author Text
          # @return [String]
          def author_text
            element = @element.caption.first
            text_exporter.new(element).export
          end
        end
      end
    end
  end
end
