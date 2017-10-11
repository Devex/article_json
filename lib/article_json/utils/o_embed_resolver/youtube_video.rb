module ArticleJSON
  module Utils
    module OEmbedResolver
      class YoutubeVideo < Base
        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "http://www.youtube.com/oembed?format=json&url=#{video_url}"
        end

        private

        # The video URL of the element
        # @return [String]
        def video_url
          "https://www.youtube.com/watch?v=#{@element.embed_id}"
        end
      end
    end
  end
end
