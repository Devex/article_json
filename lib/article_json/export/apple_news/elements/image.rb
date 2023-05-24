module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Image < Base
          # Image
          # @return [Hash]
          def export
            {
              role: "image",
              URL: @element.source_url,
              caption: @element.caption.first&.content
            }.compact
          end
        end
      end
    end
  end
end
