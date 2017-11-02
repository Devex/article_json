module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Shared
            module Caption
              # Generate the caption node
              # @param [String] tag_name
              # @return [Nokogiri::XML::NodeSet]
              def caption_node(tag_name)
                create_element(tag_name) do |caption|
                  @element.caption.each do |child_element|
                    caption.add_child(text_exporter.new(child_element).export)
                  end
                end
              end

              private

              # Get the exporter class for text elements
              # @return [ArticleJSON::Export::Common::HTML::Elements::Base]
              def text_exporter
                self.class.exporter_by_type(:text)
              end
            end
          end
        end
      end
    end
  end
end
