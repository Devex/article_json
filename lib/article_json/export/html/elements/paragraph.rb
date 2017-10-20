module ArticleJSON
  module Export
    module HTML
      module Elements
        class Paragraph < Base
          # Generate the paragraph node with its containing text elements
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(:p) do |p|
              @element.content.each do |child_element|
                p.add_child(Text.new(child_element).export)
              end
            end
          end
        end
      end
    end
  end
end
