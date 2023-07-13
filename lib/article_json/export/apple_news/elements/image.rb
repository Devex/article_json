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
              format: 'html',
              layout: 'captionLayout',
              textStyle: 'captionStyle',
            }
          end

          # Get the exporter class for text elements
          # @return [ArticleJSON::Export::Common::HTML::Elements::Base]
          def text_exporter
            self.class.exporter_by_type(:text)
          end

          # Caption Text
          # @return [String]
          def caption_text
            text.empty? ? nil : text
          end

          # @return [String]
          def text
            @element.caption.map do |child_element|
              text_exporter.new(child_element)
                .export
            end.join
          end
        end
      end
    end
  end
end
