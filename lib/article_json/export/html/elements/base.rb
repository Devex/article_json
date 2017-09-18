module ArticleJSON
  module Export
    module HTML
      module Elements
        class Base
          # @param [ArticleJSON::Elements::Base] element
          def initialize(element)
            @element = element
          end

          # Build a HTML node out of the given element
          # Dynamically looks up the right export-element-class, instantiates it
          # and then calls the #build method.
          # @return [Nokogiri::HTML::Node]
          def build
            klass = self.class.element_classes[@element.type]
            klass.new(@element).build unless klass.nil?
          end

          private

          def create_element(tag, *args)
            Nokogiri::HTML.fragment('').document.create_element(tag.to_s, *args)
          end

          def create_text_node(text)
            Nokogiri::HTML.fragment(text).children.first
          end

          class << self
            def element_classes
              {
                text: Text,
                paragraph: Paragraph,
                heading: Heading,
                list: List,
                image: Image,
                text_box: TextBox,
                quote: Quote,
                embed: Embed,
              }
            end
          end
        end
      end
    end
  end
end
