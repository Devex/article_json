module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Heading
            # Generate the heading element with the right text
            # @return [Nokogiri::XML::NodeSet]
            def export
              create_element(tag_name, @element.content)
            end

            private

            def tag_name
              "h#{@element.level}".to_sym
            end
          end
        end
      end
    end
  end
end
