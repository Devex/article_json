module ArticleJSON
  module Utils
    module OEmbedResolver
      class Tweet < Base
        # Human readable name of the resolver
        # @return [String]
        def name
          'Tweet'
        end

        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          'https://api.twitter.com/1/statuses/oembed.json?align=center' \
            "&url=#{source_url}"
        end

        # The URL of the tweet
        # @return [String]
        def source_url
          handle, tweet_id = @element.embed_id.split('/', 2)
          "https://twitter.com/#{handle}/status/#{tweet_id}"
        end
      end
    end
  end
end
