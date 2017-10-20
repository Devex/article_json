module ArticleJSON
  module Export
    module HTML
      module Elements
        class List < Base
          # Generate the list node with its list elements
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(tag_name) do |list|
              @element.content.each do |child_element|
                list_item_wrapper = create_element(:li) do |item|
                  item.add_child(Paragraph.new(child_element).export)
                end
                list.add_child(list_item_wrapper)
              end
            end
          end

          private

          def tag_name
            @element.list_type == :ordered ? :ol : :ul
          end
        end
      end
    end
  end
end
