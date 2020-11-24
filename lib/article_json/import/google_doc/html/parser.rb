module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class Parser
          # @param [String] html
          def initialize(html)
            doc = Nokogiri::HTML(html)
            selection = if doc.xpath('//body/div').empty?
                          doc.xpath('//body')
                        else
                          doc.xpath('//body/div')
                        end
            @body_enumerator = selection.last.children.to_enum

            css_node = doc.xpath('//head/style').last
            @css_analyzer = CSSAnalyzer.new(css_node&.inner_text)
          end

          # Parse the body of the document and return the result
          # @return [Array[ArticleJSON::Elements::Base]]
          def parsed_content
            @parsed_content ||= parse_body
          end

          private

          # Loop over all body nodes and parse them
          # @return [Array[ArticleJSON::Elements::Base]]
          def parse_body
            @parsed_content = []
            while body_has_more_nodes?
              @parsed_content << begin
                @current_node = NodeAnalyzer.new(@body_enumerator.next)
                parse_current_node || next
              end
            end
            @parsed_content
          end

          # Parse the current node and return an element, if available
          # @return [ArticleJSON::Elements::Base]
          def parse_current_node
            case @current_node.type
            when :heading then parse_heading
            when :paragraph then parse_paragraph
            when :list then parse_list
            when :image then parse_image
            when :text_box then parse_text_box
            when :quote then parse_quote
            when :embed then parse_embed
            when :hr, :empty, :unknown then nil
            end
          end

          # @return [ArticleJSON::Elements::Heading]
          def parse_heading
            HeadingParser.new(node: @current_node.node).element
          end

          # @return [ArticleJSON::Elements::Paragraph|nil]
          def parse_paragraph
            paragraph =
              ParagraphParser
                .new(node: @current_node.node, css_analyzer: @css_analyzer)
                .element
            paragraph unless paragraph.blank?
          end

          # @return [ArticleJSON::Elements::List]
          def parse_list
            ListParser
              .new(node: @current_node.node, css_analyzer: @css_analyzer)
              .element
          end

          # @return [ArticleJSON::Elements::Image]
          def parse_image
            ImageParser
              .new(
                node: @current_node.node,
                caption_node: next_node,
                css_analyzer: @css_analyzer
              )
              .element
          end

          # @return [ArticleJSON::Elements::TextBox]
          def parse_text_box
            TextBoxParser
              .new(
                type_node: @current_node.node,
                nodes: nodes_until_hr,
                css_analyzer: @css_analyzer
              )
              .element
          end

          # @return [ArticleJSON::Elements::Quote]
          def parse_quote
            QuoteParser
              .new(nodes: nodes_until_hr, css_analyzer: @css_analyzer)
              .element
          end

          # @return [ArticleJSON::Elements::Embed]
          def parse_embed
            EmbeddedParser.build(
              node: @current_node.node,
              caption_node: next_node,
              css_analyzer: @css_analyzer
            )
          end

          # Collect all nodes until a horizontal line, advancing the enumerator
          # @return [Array[Nokogiri::HTML::Node]]
          def nodes_until_hr
            nodes = []
            until !body_has_more_nodes? ||
                NodeAnalyzer.new(@body_enumerator.peek).hr?
              nodes << @body_enumerator.next
            end
            nodes
          end

          # Return the next node if available, and advance the enumerator
          # @return [Nokogiri::HTML::Node]
          def next_node
            body_has_more_nodes? ? @body_enumerator.next : nil
          end

          # @return [Boolean]
          def body_has_more_nodes?
            @body_enumerator.peek
            true
          rescue StopIteration
            false
          end
        end
      end
    end
  end
end
