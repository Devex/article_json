module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class HeadingElement
          # @param [Nokogiri::HTML::Node] node
          def initialize(node:)
            @node = node
          end

          # The raw text content of the heading, without any markup
          # @return [String]
          def content
            @node.inner_text
          end

          # Determine the level of the heading
          # The level corresponds to the header tag, e.g. `<h3>` is level 3.
          # @return [Integer]
          def level
            case @node.name
              when 'h1' then 1
              when 'h2' then 2
              when 'h3' then 3
              when 'h4' then 4
              when 'h5' then 5
            end
          end

          # Hash representation of this heading element
          # @return [Hash]
          def to_h
            {
              type: :heading,
              level: level,
              content: content
            }
          end
        end
      end
    end
  end
end
