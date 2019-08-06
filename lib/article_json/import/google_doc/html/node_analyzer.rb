module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class NodeAnalyzer
          attr_reader :node

          # @param [Nokogiri::HTML::Node] node
          def initialize(node)
            @node = node
          end

          # Check if a node equals a certain text
          # @param [String] text
          # @return [Boolean]
          def has_text?(text)
            node.inner_text.strip.downcase == text.strip.downcase
          end

          # Check if the node text begins with a certain text
          # @param [String]
          # @return [Boolean]
          def begins_with?(text)
            first_word = node.inner_text.strip.downcase.split(' ').first
            first_word == text.strip.downcase
          end

          # Check if the node is empty, i.e. not containing any text
          # Given that images are the only nodes without text, we have to make
          # sure that it's not an image.
          # @return [Boolean]
          def empty?
            return @is_empty if defined? @is_empty
            @is_empty = node.inner_text.strip.empty? && !image? && !hr? && !br?
          end

          # Check if the node is a header tag between <h1> and <h5>
          # @return [Boolean]
          def heading?
            return @is_heading if defined? @is_heading
            @is_heading =
              !quote? && !text_box? && %w(h1 h2 h3 h4 h5).include?(node.name)
          end

          # Check if the node is a horizontal line (i.e. `<hr>`)
          # @return [Boolean]
          def hr?
            node.name == 'hr'
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
                !quote? &&
                !embed?
          end

          # Check if the node contains an ordered or unordered list
          # @return [Boolean]
          def list?
            return @is_list if defined? @is_list
            @is_list = %w(ul ol).include?(node.name)
          end

          # Check if the node starts a text box
          # Text boxes start with a single line saying "Textbox:" or "Highlight:".
          # @return [Boolean]
          def text_box?
            return @is_text_box if defined? @is_text_box
            @is_text_box = begins_with?('textbox:') || begins_with?('highlight:')
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

          # Check if the node contains an embedded element
          # @return [Boolean]
          def embed?
            return @is_embed if defined? @is_embed
            @is_embed = EmbeddedParser.supported?(node)
          end

          # Check if the node is a linebreak. A span only containing whitespaces
          # and <br> tags is considered a linebreak.
          # @return [Boolean]
          def br?
            return @is_br if defined? @is_br
            @is_br = node.name == 'br' || only_includes_brs?
          end

          # Determine the type of this node
          # The type is one of the elements supported by article_json.
          # @return [Symbol]
          def type
            return :empty if empty?
            return :hr if hr?
            return :heading if heading?
            return :paragraph if paragraph?
            return :list if list?
            return :text_box if text_box?
            return :quote if quote?
            return :image if image?
            return :embed if embed?
            :unknown
          end

          private

          # Return true if the node only contains <br> nodes and empty text
          # @return [Boolean]
          def only_includes_brs?
            return false unless node.inner_text.strip.empty?
            tags = node.children.map(&:name)
            # Check if it only contains <br> and text nodes
            return false unless tags.all? { |tag| %w(br text).include? tag }
            # Check if at least one is a `<br>` node
            tags.include?('br')
          end
        end
      end
    end
  end
end
