module ArticleJSON
  module Export
    module HTML
      module Elements
        class Heading < Base
          # Generate the heading element node with the right text
          # @return [Nokogiri::XML::Element]
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
