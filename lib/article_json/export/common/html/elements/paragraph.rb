module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Paragraph
            # Generate the paragraph node with its containing text elements
            # @return [Nokogiri::XML::NodeSet]
            def export
              create_element(:p) do |p|
                @element.content.each do |child_element|
                  p.add_child(text_exporter.new(child_element).export)
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
