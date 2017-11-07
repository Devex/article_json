module ArticleJSON
  module Utils
    module OEmbedResolver
      class FacebookVideo < Base
        # Human readable name of the resolver
        # @return [String]
        def name
          'Facebook video'
        end

        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "https://www.facebook.com/plugins/video/oembed.json?url=#{source_url}"
        end

        # The video URL of the element
        # @return [String]
        def source_url
          "https://www.facebook.com/facebook/videos/#{@element.embed_id}"
        end
      end
    end
  end
end
