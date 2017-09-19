module ArticleJSON
  module Utils
    module OEmbedResolver
      class Base
        # @param [ArticleJSON::Elements::Embed] embed_element
        def initialize(embed_element)
          @element = embed_element
        end

        # @return [Hash]
        def oembed_data
          resolver = self.class == Base ? self.class.build(@element) : self
          resolver.parsed_api_response
        end

        protected

        # @return [Hash]
        def parsed_api_response
          @api_response ||= begin
            uri = URI.parse(oembed_url)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = (uri.scheme == 'https')
            response = http.request(Net::HTTP::Get.new(uri, http_headers))
            JSON.parse(response.body, symbolize_names: true)
          end
        end

        # @return [Hash]
        def http_headers
          headers = { 'Content-Type' => 'application/json' }
          unless ArticleJSON.configuration.oembed_user_agent.nil?
            headers['User-Agent'] = ArticleJSON.configuration.oembed_user_agent
          end
          headers
        end

        class << self
          # Instantiate the correct sub class for a given element
          # @param [ArticleJSON::Elements::Embed] embed_element
          # @return [ArticleJSON::Utils::OEmbedResolver::Base]
          def build(embed_element)
            resolver = resolver_by_embed_type(embed_element.embed_type)
            resolver.new(embed_element) unless resolver.nil?
          end

          # Lookup the correct sub class for a given element type
          # @param [Symbol] :type
          # @return [ArticleJSON::Utils::OEmbedResolver::Base]
          def resolver_by_embed_type(type)
            {
              facebook_video: FacebookVideo,
              vimeo_video: VimeoVideo,
              youtube_video: YoutubeVideo,
            }[type.to_sym]
          end
        end
      end
    end
  end
end
