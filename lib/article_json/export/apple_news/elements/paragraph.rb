module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Paragraph < Base
          # Generate the paragraph node with its containing text elements
          # @return [Hash]
          def export
            {
              role: 'body',
              text: text,
              format: 'html'
            }
          end

          private

          # Get the exporter class for text elements
          # @return [ArticleJSON::Export::Common::HTML::Elements::Base]
          def text_exporter
            self.class.exporter_by_type(:text)
          end

          def text
            @element.content.map do |child_element|
              text_exporter.new(child_element)
                .export
            end.join
          end
        end
      end
    end
  end
end
