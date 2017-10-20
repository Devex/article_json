module ArticleJSON
  module Export
    module HTML
      module Elements
        class Base
          # @param [ArticleJSON::Elements::Base] element
          def initialize(element)
            @element = element
          end

          # Export a HTML node out of the given element
          # Dynamically looks up the right export-element-class, instantiates it
          # and then calls the #build method.
          # @return [Nokogiri::XML::NodeSet]
          def export
            exporter = self.class == Base ? self.class.build(@element) : self
            exporter.export unless exporter.nil?
          end

          private

          # Create a Nokogiri NodeSet wrapping a Node with the given `tag`
          # @param [Symbol] tag - type of the created element
          # @param [*Object] args - additional arguments for the element
          # @yield [Nokogiri::XML::Element] Optional block can be passed, will
          #                                 be executed with the generated
          #                                 element as a parameter
          # @return [Nokogiri::XML::NodeSet] Generated main element wrapped in a
          #                                  NodeSet
          def create_element(tag, *args)
            document = Nokogiri::HTML.fragment('').document
            element = document.create_element(tag.to_s, *args)
            yield(element) if block_given?
            wrap_in_node_set([element], document)
          end

          # Wrap a given list of Nokogiri Nodes in NodeSets
          # @param [Array[Nokogiri::XML::Node]] elements
          # @param [Nokogiri::HTML::Document] document
          # @return [Nokogiri::XML::NodeSet]
          def wrap_in_node_set(elements, document)
            Nokogiri::XML::NodeSet.new(document).tap do |node_set|
              elements.each { |element| node_set.push(element) }
            end
          end

          # @param [String] text
          # @return [Nokogiri::XML::NodeSet]
          def create_text_node(text)
            Nokogiri::HTML.fragment(text).children
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
              key = type.to_sym
              ArticleJSON.configuration.element_exporter_for(:html, key) ||
                default_exporter_mapping[key]
            end

            private

            def default_exporter_mapping
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
