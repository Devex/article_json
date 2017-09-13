module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class ListElement
          # @param [Nokogiri::HTML::Node] node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, css_analyzer:)
            @node = node
            @css_analyzer = css_analyzer
          end

          # Determine the list type, either ordered or unordered
          # @return [Symbol]
          def list_type
            case @node.name
              when 'ol' then :ordered
              when 'ul' then :unordered
            end
          end

          # Parse the list's sub nodes to get a set of paragraphs
          # @return [Array[ArticleJSON::Import::GoogleDoc::HTML::ParagraphParser]]
          def content
            @node
              .children
              .select { |node| node.name == 'li' }
              .map do |node|
                ParagraphParser.new(node: node, css_analyzer: @css_analyzer)
              end
          end

          # Hash representation of this list
          # @return [Hash]
          def to_h
            {
              type: :list,
              list_type: list_type,
              content: content.map(&:to_h),
            }
          end
        end
      end
    end
  end
end
