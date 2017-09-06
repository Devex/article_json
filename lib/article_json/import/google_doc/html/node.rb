module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class Node
          attr_reader :node

          # @param [Nokogiri::XML::Node] node
          def initialize(node)
            @node = node
          end

          # Check if the node is a header tag between <h1> and <h5>
          # @return [Boolean]
          def heading?
            %w(h1 h2 h3 h4 h5).include?(node.name)
          end

          # Check if a node equals a certain text
          # @param [String] text
          # @return [Boolean]
          def has_text?(text)
            node.inner_text.strip.downcase == text.strip.downcase
          end

          # Check if the node is empty, i.e. not containing any text or nested
          # nodes of any importance - empty spans as not important ;)
          # @return [Boolean]
          def empty?
            node.inner_text.strip.empty? &&
              (node.children.empty? ||
                node.children.all? { |c| %w(span text).include?(c.name) })
          end

          # Check if the node contains an image
          # @return [Boolean]
          def image?
            node.xpath('.//img').length > 0
          end
        end
      end
    end
  end
end
