module ArticleJSON
  module Export
    module PlainText
      module Elements
        class Quote < Base
          # Quotes are just rendered with a preceding blank line. If a caption
          # is present, it is rendered below the quote indented with two dashes.
          # @return [String]
          def export
            "\n#{quote_text}\n"
          end

          private

          # Plain text representation of the entire quote
          # @return [String]
          def quote_text
            extract_text(@element.content).tap do |text|
              if @element.caption&.any?
                text << " --#{extract_text(@element.caption)}\n"
              end
            end
          end

          # Extract plain text from given element
          # @param [ArticleJSON::Elements::Base] elements
          # @return [String]
          def extract_text(elements)
            elements.map { |text| base_class.new(text).export }.join
          end
        end
      end
    end
  end
end
