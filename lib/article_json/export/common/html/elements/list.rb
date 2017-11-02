module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module List
            # Generate the list node with its elements
            # @return [Nokogiri::XML::NodeSet]
            def export
              create_element(tag_name) do |list|
                @element.content.each do |child_element|
                  list_item_wrapper = create_element(:li) do |item|
                    item.add_child(paragraph_exporter.new(child_element).export)
                  end
                  list.add_child(list_item_wrapper)
                end
              end
            end

            private

            def tag_name
              @element.list_type == :ordered ? :ol : :ul
            end

            # Get the exporter class for paragraph elements
            # @return [ArticleJSON::Export::Common::HTML::Elements::Base]
            def paragraph_exporter
              self.class.exporter_by_type(:paragraph)
            end
          end
        end
      end
    end
  end
end
