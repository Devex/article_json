module ArticleJSON
  module Utils
    module OEmbedResolver
      class VimeoVideo < Base
        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "https://vimeo.com/api/oembed.json?url=#{video_url}"
        end

        private

        # The video URL of the element
        # @return [String]
        def video_url
          "https://vimeo.com/#{@element.embed_id}"
        end
      end
    end
  end
end
