module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Base
            # Also include the generic base element concern
            def self.included(base)
              base.include ArticleJSON::Export::Common::Elements::Base
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
          end
        end
      end
    end
  end
end
