module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class List < Base
          # List
          # @return [Hash]
          def export
            {
              role: 'body',
              text: list_text,
              format: 'html',
              layout: 'bodyLayout',
              textStyle: 'bodyStyle',
            }
          end

          private

          # Get the exporter class for text elements
          #
          # @return [ArticleJSON::Export::Common::HTML::Elements::<Class>]
          def text_exporter
            self.class.exporter_by_type(:text)
          end

          # When it is an unordered list wrap it in <ul></ul>
          # When it is an ordered list wrap it in <ol></ol>
          #
          # List Text
          # @return [String]
          def list_text
            prepend_list_tag + list + append_list_tag
          end

          # Each list item should be wrapped in <li></li>
          #
          # @return [String]
          def list
            @element.content.map do |paragraph_element|
              line_item = paragraph_element.content.map do |text_element|
                text_exporter.new(text_element).export
              end.join

              "<li>#{line_item}</li>"
            end.join
          end

          # @return [String]
          def prepend_list_tag
            ordered_list? ? '<ol>' : '<ul>'
          end

          # @return [String]
          def append_list_tag
            ordered_list? ? '</ol>' : '</ul>'
          end

          # @return [Boolean]
          def ordered_list?
            @element.list_type == :ordered
          end
        end
      end
    end
  end
end
