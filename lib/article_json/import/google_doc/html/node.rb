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
          # nodes of any importance - empty spans are not important ;)
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

          # Check if the node contains an ordered or unordered list
          # @return [Boolean]
          def list?
            %w(ul ol).include?(node.name)
          end

          # Check if the node starts a text box
          # Text boxes start with a single line saying "Textbox:".
          # @return [Boolean]
          def text_box?
            has_text?('textbox:')
          end

          # Check if the node starts a highlight box
          # Story highlights start with a single line saying "Highlight:".
          # @return [Boolean]
          def highlight?
            has_text?('highlight:')
          end

          # Check if the node starts a quote
          # Quotes start with a single line saying "Quote:".
          # @return [Boolean]
          def quote?
            has_text?('quote:')
          end

          # Determine the type of this node
          # The type is one of the elements supported by article_json.
          # @return [Symbol]
          def type
            return :empty if empty?
            return :image if image?
            return :text_box if text_box?
            return :highlight if highlight?
            return :quote if quote?
            return :heading if heading?
            return :list if list?
            :text
          end
        end
      end
    end
  end
end
