module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class TextBox < Base
          include ArticleJSON::Export::Common::HTML::Elements::TextBox

          # Generate a `<div>` node containing all text box elements and
          # surrounded by an ASCII-art line to the top and bottom
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(:div, class: 'text-box') do |div|
              div.add_child(ascii_art_line_node)
              @element.content.each do |child_element|
                div.add_child(base_class.new(child_element).export)
              end
              div.add_child(ascii_art_line_node)
            end
          end

          private

          # Returns a paragraph with the `ascii_art_line_text_element`. This
          # gets inserted above and below the text box content
          # @return [Nokogiri::XML::NodeSet]
          def ascii_art_line_node
            create_element(:p) { |p| p.add_child ascii_art_line_text_element }
          end

          # Returns the delimiter of text boxes. Overwrite this method to have a
          # custom text box delimiter
          # @return [String]
          def ascii_art_line_text_element
            '────────'
          end
        end
      end
    end
  end
end
