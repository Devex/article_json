module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class ImageParser
          include Shared::Caption
          include Shared::Float

          # @param [Nokogiri::HTML::Node] node
          # @param [Nokogiri::HTML::Node] caption_node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, caption_node:, css_analyzer:)
            @node = node
            @caption_node = caption_node
            @css_analyzer = css_analyzer

            # Main node indicates the floating behavior
            @float_node = @node
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
            super if floatable_size?
          end

          # @return [ArticleJSON::Elements::Image]
          def element
            ArticleJSON::Elements::Image.new(
              source_url: source_url,
              float: float,
              caption: caption
            )
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
