module ArticleJSON
  module Export
    module PlainText
      module Elements
        class Paragraph < Base
          # Plain text from the paragraph. Any formatting is disregarded.
          # Followed by a newline.
          # @return [String]
          def export
            "#{text}\n"
          end

          private

          # Plain text of the paragraph
          # @return [String]
          def text
            @element
              .content
              &.map { |text_element| text_exporter.new(text_element).export }
              &.join
          end

          # Get the exporter class for text elements
          # @return [ArticleJSON::Export::PlainText::Elements::Base]
          def text_exporter
            self.class.exporter_by_type(:text)
          end
        end
      end
    end
  end
end
