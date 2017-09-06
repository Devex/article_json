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

          # Check if a node equals a certain text
          # @param [String] text
          # @return [Boolean]
          def has_text?(text)
            node.inner_text.strip.downcase == text.strip.downcase
          end

          # Check if the node is empty, i.e. not containing any text
          # Given that images are the only nodes without text, we have to make
          # sure that it's not an image.
          # @return [Boolean]
          def empty?
            return @is_empty if defined? @is_empty
            @is_empty = node.inner_text.strip.empty? && !image?
          end

          # Check if the node is a header tag between <h1> and <h5>
          # @return [Boolean]
          def heading?
            return @is_heading if defined? @is_heading
            @is_heading = %w(h1 h2 h3 h4 h5).include?(node.name)
          end

          # Check if the node is a normal text paragraph
          # @return [Boolean]
          def paragraph?
            return @is_paragraph if defined? @is_paragraph
            @is_paragraph =
              node.name == 'p' &&
                !empty? &&
                !image? &&
                !text_box? &&
                !highlight? &&
                !quote?
          end

          # Check if the node contains an ordered or unordered list
          # @return [Boolean]
          def list?
            return @is_list if defined? @is_list
            @is_list = %w(ul ol).include?(node.name)
          end

          # Check if the node starts a text box
          # Text boxes start with a single line saying "Textbox:".
          # @return [Boolean]
          def text_box?
            return @is_text_box if defined? @is_text_box
            @is_text_box = has_text?('textbox:')
          end

          # Check if the node starts a highlight box
          # Story highlights start with a single line saying "Highlight:".
          # @return [Boolean]
          def highlight?
            return @is_highlight if defined? @is_highlight
            @is_highlight = has_text?('highlight:')
          end

          # Check if the node starts a quote
          # Quotes start with a single line saying "Quote:".
          # @return [Boolean]
          def quote?
            return @is_quote if defined? @is_quote
            @is_quote = has_text?('quote:')
          end

          # Check if the node contains an image
          # @return [Boolean]
          def image?
            return @is_image if defined? @is_image
            @is_image = node.xpath('.//img').length > 0
          end

          # Determine the type of this node
          # The type is one of the elements supported by article_json.
          # @return [Symbol]
          def type
            return :empty if empty?
            return :heading if heading?
            return :paragraph if paragraph?
            return :list if list?
            return :text_box if text_box?
            return :highlight if highlight?
            return :quote if quote?
            return :image if image?
            :unknown
          end
        end
      end
    end
  end
end
