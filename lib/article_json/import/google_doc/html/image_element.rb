module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class ImageElement
          # @param [Nokogiri::HTML::Node] node
          # @param [Nokogiri::HTML::Node] caption_node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, caption_node:, css_analyzer:)
            @node = node
            @caption_node = caption_node
            @css_analyzer = css_analyzer
          end

          # The value of the image's `src` attribute
          # @return [String]
          def source_url
            image_node.attribute('src').value
          end

          # The node of the actual image
          # @return [Nokogiri::HTML::Node]
          def image_node
            @node.xpath('.//img').first
          end

          # Check if the image is floating (left, right or not at all)
          # @return [Symbol]
          def float
            return unless floatable_size? && @node.has_attribute?('class')

            node_class = @node.attribute('class').value
            return :right if @css_analyzer.right_aligned?(node_class)
            return :left if @css_analyzer.left_aligned?(node_class)

            nil
          end

          # @return [Array[ArticleJSON::Import::GoogleDoc::HTML::TextElement]]
          def caption
            TextElement.extract(
              node: @caption_node,
              css_analyzer: @css_analyzer
            )
          end

          # Hash representation of this image element
          # @return [Hash]
          def to_h
            {
              type: :image,
              source_url: source_url,
              float: float,
              original_width: image_width,
              caption: caption.map(&:to_h),
            }
          end

          private

          # Check if the image's width can be determined and is less than 500px
          # This is about 3/4 of the google document width...
          # @return [Boolean]
          def floatable_size?
            image_width && image_width < 500
          end

          # Get the specified width of the image if available
          # The width can either be specified in a width attribute or via style
          # attribute. If not, `nil` is returned.
          # @return [Integer]
          def image_width
            @image_width ||=
              if image_node.has_attribute?('width')
                image_node.attribute('width').value.to_i
              elsif image_node.has_attribute?('style')
                regex = /width:\s?(?<px>\d+|(\d+?\.\d+))px/
                match = image_node.attribute('style').value.match(regex)
                match['px'].to_i if match && match['px']
              end
          end
        end
      end
    end
  end
end
