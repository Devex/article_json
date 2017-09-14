module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class QuoteParser
          include Shared::Caption

          # @param [Array[Nokogiri::HTML::Node]] nodes
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(nodes:, css_analyzer:)
            @nodes = nodes.reject { |node| NodeAnalyzer.new(node).empty? }
            @caption_node = @nodes.last
            @css_analyzer = css_analyzer
          end

          # Check if the quote is floating (left, right or not at all)
          # The first paragraph of the quote indicates its floating value.
          # @return [Symbol]
          def float
            node_class = @nodes.first.attribute('class')&.value || ''
            return :right if @css_analyzer.right_aligned?(node_class)
            return :left if @css_analyzer.left_aligned?(node_class)
            nil
          end

          # Parse the quote's nodes to get a set of paragraphs
          # The last node is ignored as it contains the quote caption
          # @return [Array[ArticleJSON::Elements::Paragraph]]
          def content
            @nodes
              .take(@nodes.size - 1)
              .map do |node|
                ParagraphParser
                  .new(node: node, css_analyzer: @css_analyzer)
                  .element
              end
          end

          # @return [ArticleJSON::Elements::Quote]
          def element
            ArticleJSON::Elements::Quote.new(
              content: content,
              caption: caption,
              float: float
            )
          end
        end
      end
    end
  end
end
