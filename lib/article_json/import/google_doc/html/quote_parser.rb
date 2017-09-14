module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class QuoteParser
          include Shared::Caption
          include Shared::Float

          # @param [Array[Nokogiri::HTML::Node]] nodes
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(nodes:, css_analyzer:)
            @nodes = nodes.reject { |node| NodeAnalyzer.new(node).empty? }
            @css_analyzer = css_analyzer

            # First node of the quote indicates floating behavior
            @float_node = @nodes.first
            # Last node of the quote contains the caption
            @caption_node = @nodes.last
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
