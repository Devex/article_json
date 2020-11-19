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
          "https://graph.facebook.com/v9.0/oembed_video?url=#{source_url}" \
          "&access_token=#{access_token}"
        end

        # The video URL of the element
        # @return [String]
        def source_url
          "https://www.facebook.com/facebook/videos/#{@element.embed_id}"
        end

        # The facebook access token. If not set, it raises an exception
        # explaining how to configure it.
        #
        # @return [String]
        def access_token
          token = ArticleJSON.configuration.facebook_token

          if token.nil?
            raise 'You need to configure the facebook token to use facebook' \
                  'embed videos, see:' \
                  'https://github.com/Devex/article_json#facebook-oembed'
          end
          token
        end
      end
    end
  end
end
