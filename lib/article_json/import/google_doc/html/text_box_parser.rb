module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class TextBoxParser
          # @param [Array[Nokogiri::HTML::Node]] nodes
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(nodes:, css_analyzer:)
            @nodes = nodes.reject { |node| NodeAnalyzer.new(node).empty? }
            @css_analyzer = css_analyzer
          end

          # Check if the text box is floating (left, right or not at all)
          # The first paragraph of the text box indicates its floating value.
          # @return [Symbol]
          def float
            node_class = @nodes.first.attribute('class')&.value || ''
            return :right if @css_analyzer.right_aligned?(node_class)
            return :left if @css_analyzer.left_aligned?(node_class)
            nil
          end

          # Parse the text box's nodes to get a list of sub elements
          # Supported sub elements are: headings, paragraphs & lists.
          # @return [Array]
          def content
            @nodes.map { |node| parse_sub_node(node) }.compact
          end

          # Hash representation of this text box
          # @return [ArticleJSON::Elements::TextBox]
          def element
            ArticleJSON::Elements::TextBox.new(float: float, content: content)
          end

          private

          def parse_sub_node(node)
            case NodeAnalyzer.new(node).type
            when :heading
              HeadingParser.new(node: node).element
            when :paragraph
              ParagraphParser
                .new(node: node, css_analyzer: @css_analyzer)
                .element
            when :list
              ListParser.new(node: node, css_analyzer: @css_analyzer).element
            end
          end
        end
      end
    end
  end
end
