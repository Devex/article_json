module ArticleJSON
  module Export
    module AMP
      module Elements
        class Base
          # @param [ArticleJSON::Elements::Base] element
          def initialize(element)
            @element = element
          end

          # Export a HTML node out of the given element
          # Dynamically looks up the right export-element-class, instantiates it
          # and then calls the #build method.
          # @return [Nokogiri::HTML::Node]
          def export
            exporter = self.class == Base ? self.class.build(@element) : self
            exporter.export unless exporter.nil?
          end

          private

          def create_element(tag, *args)
            Nokogiri::HTML.fragment('').document.create_element(tag.to_s, *args)
          end

          def create_text_node(text)
            Nokogiri::HTML.fragment(text).children.first
          end

          class << self
            # Instantiate the correct sub class for a given element
            # @param [ArticleJSON::Elements::Base] element
            # @return [ArticleJSON::Export::HTML::Elements::Base]
            def build(element)
              klass = exporter_by_type(element.type)
              klass.new(element) unless klass.nil?
            end

            # Look up the correct exporter class based on the element type
            # @param [Symbol] type
            # @return [ArticleJSON::Export::HTML::Elements::Base]
            def exporter_by_type(type)
              {
                text: Text,
                paragraph: Paragraph,
                heading: Heading,
                list: List,
                quote: Quote,
                image: Image,
                embed: Embed,
                text_box: TextBox,
              }[type.to_sym]
            end
          end
        end
      end
    end
  end
end
