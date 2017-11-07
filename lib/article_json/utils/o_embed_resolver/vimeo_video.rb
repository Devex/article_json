module ArticleJSON
  module Utils
    module OEmbedResolver
      class VimeoVideo < Base
        # Human readable name of the resolver
        # @return [String]
        def name
          'Vimeo video'
        end

        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "https://vimeo.com/api/oembed.json?url=#{source_url}"
        end

        # The video URL of the element
        # @return [String]
        def source_url
          "https://vimeo.com/#{@element.embed_id}"
        end
      end
    end
  end
end
