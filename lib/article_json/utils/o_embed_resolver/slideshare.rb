module ArticleJSON
  module Utils
    module OEmbedResolver
      class Slideshare < Base
        # Human readable name of the resolver
        # @return [String]
        def name
          'Slideshare deck'
        end

        # The URL for the oembed API call
        # @return [String]
        def oembed_url
          'https://www.slideshare.net/api/oembed/2?format=json&url='\
          "#{source_url}"
        end

        # The URL of the slideshow
        # @return [String]
        def source_url
          handle, slug = @element.embed_id.split('/', 2)
          "https://www.slideshare.net/#{handle}/#{slug}"
        end
      end
    end
  end
end
