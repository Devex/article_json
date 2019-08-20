module ArticleJSON
  module Utils
    module OEmbedResolver
      class Soundcloud < Base
        # Human readable name of the resolver
        # @return [String]
        def name
          'Soundcloud'
        end

        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "https://soundcloud.com/oembed?url=#{source_url}&format=json"
        end

        # The URL of the element
        # @return [String]
        def source_url
          "https://soundcloud.com/#{@element.embed_id}"
        end
      end
    end
  end
end
