module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Image < Base
          # Image | Image, Caption
          # @return [Hash, Array<Hash>]
          def export
            caption_text.nil? ? image : [image, caption]
          end

          private
          # Image
          # @return [Hash]
          def image
            {
              role: 'image',
              URL: @element.source_url,
              caption: caption_text,
            }.compact
          end

          # Caption
          # @return [Hash]
          def caption
            {
              role: 'caption',
              text: caption_text,
              layout: 'captionLayout',
              textStyle: 'captionStyle',
            }
          end

          # Caption Text
          # @return [String]
          def caption_text
            @element.caption.first&.content
          end
        end
      end
    end
  end
end
