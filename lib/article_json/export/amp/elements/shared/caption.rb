module ArticleJSON
  module Export
    module AMP
      module Elements
        module Shared
          module Caption
            # Generate the caption node
            # @param [String] tag_name
            # @return [Nokogiri::XML::NodeSet]
            def caption_node(tag_name)
              create_element(tag_name) do |caption|
                @element.caption.each do |child_element|
                  caption.add_child(Text.new(child_element).export)
                end
              end
            end
          end
        end
      end
    end
  end
end
