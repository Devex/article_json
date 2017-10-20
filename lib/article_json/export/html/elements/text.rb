module ArticleJSON
  module Export
    module HTML
      module Elements
        class Text < Base
          # Generate a Nokogiri node or simple text node, depending on the text
          # options
          # @return [Nokogiri::XML::NodeSet]
          def export
            return bold_and_italic_node if @element.bold && @element.italic
            return bold_node if @element.bold
            return italic_node if @element.italic
            content_node
          end

          private

          # @return [Nokogiri::XML::NodeSet]
          def italic_node
            create_element(:em) { |em| em.add_child(content_node) }
          end

          # @return [Nokogiri::XML::NodeSet]
          def bold_node
            create_element(:strong) do |strong|
              strong.add_child(content_node)
            end
          end

          # @return [Nokogiri::XML::NodeSet]
          def bold_and_italic_node
            create_element(:strong) do |strong|
              strong.add_child(italic_node)
            end
          end

          # @return [Nokogiri::XML::NodeSet]
          def content_node
            return create_text_node(@element.content) if @element.href.nil?
            create_element(:a, @element.content, href: @element.href)
          end
        end
      end
    end
  end
end
