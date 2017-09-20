module ArticleJSON
  module Utils
    module OEmbedResolver
      class Slideshare < Base
        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          "https://www.slideshare.net/api/oembed/2?format=json&url=#{slide_url}"
        end

        private

        # The URL of the slideshow
        # @return [String]
        def slide_url
          handle, slug = @element.embed_id.split('/', 2)
          "www.slideshare.net/#{handle}/#{slug}"
        end
      end
    end
  end
end
