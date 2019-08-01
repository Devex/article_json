module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class TextBoxParser
          include Shared::Float

          # @param [Nokogiri::HTML::Node] type_node Document node that states
          #                                         that this is a textbox.
          #                                         May contain tags, too.
          # @param [Array[Nokogiri::HTML::Node]] nodes
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(type_node: ,nodes:, css_analyzer:)
            @nodes = nodes.reject { |node| NodeAnalyzer.new(node).empty? }
            @css_analyzer = css_analyzer

            # First node of the text box indicates floating behavior
            @float_node = @nodes.first
            @type_node = type_node
          end

          # Parse the text box's nodes to get a list of sub elements
          # Supported sub elements are: headings, paragraphs & lists.
          # @return [Array]
          def content
            @nodes.map { |node| parse_sub_node(node) }.compact
          end

          # Extract any potential tags, specified in brackets after the Textbox definition
          # @return [Array[Symbol]]
          def tags
            match = /(.*?)[\s\u00A0]+\[(?<tags>.*)\]/
                      .match(@type_node.inner_text)
            return [] unless match
            match[:tags].split(' ')
          end

          # Hash representation of this text box
          # @return [ArticleJSON::Elements::TextBox]
          def element
            ArticleJSON::Elements::TextBox.new(
              float: float,
              content: content,
              tags: tags
            )
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
