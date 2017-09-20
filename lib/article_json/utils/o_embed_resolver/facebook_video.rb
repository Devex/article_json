module ArticleJSON
  module Utils
    module OEmbedResolver
      class FacebookVideo < Base
        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "https://www.facebook.com/plugins/video/oembed.json?url=#{video_url}"
        end

        private

        # The video URL of the element
        # @return [String]
        def video_url
          "facebook.com/facebook/videos/#{@element.embed_id}"
        end
      end
    end
  end
end
