module ArticleJSON
  module Utils
    module OEmbedResolver
      class YoutubeVideo < Base
        # Human readable name of the resolver
        # @return [String]
        def name
          'Youtube video'
        end

        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "http://www.youtube.com/oembed?format=json&url=#{source_url}"
        end

        # The video URL of the element
        # @return [String]
        def source_url
          "https://www.youtube.com/watch?v=#{@element.embed_id}"
        end
      end
    end
  end
end
