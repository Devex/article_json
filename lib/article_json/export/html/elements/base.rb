module ArticleJSON
  module Export
    module HTML
      module Elements
        class Base
          # @param [ArticleJSON::Elements::Base] element
          def initialize(element)
            @element = element
          end

          private

          def create_element(tag, *args)
            Nokogiri::HTML.fragment('').document.create_element(tag.to_s, *args)
          end

          def create_text_node(text)
            Nokogiri::HTML.fragment(text).children.first
          end
        end
      end
    end
  end
end
