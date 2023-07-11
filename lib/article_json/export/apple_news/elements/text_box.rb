module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class TextBox < Base
          include ArticleJSON::Export::Common::HTML::Elements::TextBox
          # List
          # @return [Hash]
          def export
            {
              role: 'container',
              layout: 'textBoxLayout',
              style: 'textBoxStyle',
              animation: {
                type: 'appear',
                userControllable: true,
                initialAlpha: 0.0,
              },
              components: map_styles(elements),
            }
          end

          private

          # @return [Array]
          def elements
            @element.content.map do |child_element|
              case child_element
              when ArticleJSON::Elements::Heading
                namespace::Heading.new(child_element).export
              when ArticleJSON::Elements::Paragraph
                namespace::Paragraph.new(child_element).export
              when ArticleJSON::Elements::List
                namespace::List.new(child_element).export
              else
                namespace::Text.new(child_element).export
              end
            end
          end

          # @return [Module]
          def namespace
            ArticleJSON::Export::AppleNews::Elements
          end

          # @return [Array]
          def map_styles(elements)
            elements.map do |child_element|
              child_element.merge(layout: 'textBox' +  child_element[:layout].upcase_first)
            end
          end
        end
      end
    end
  end
end
