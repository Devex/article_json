module ArticleJSON
  module Export
    module AMP
      # AMP uses custom HTML tags for elements like iframes or embedded youtube
      # videos. These elements each require a javascript to be loaded to be
      # properly rendered by the browser. This class resolves the custom tags to
      # a list of javascript libraries which then can be included on the page.
      class CustomElementLibraryResolver
        # @param [Array[Symbol]] custom_element_tags
        def initialize(custom_element_tags)
          @custom_element_tags = custom_element_tags
        end

        # List of all custom tags with their library source URI
        # @return [Hash[Symbol => String]]
        def sources
          @custom_element_tags.each_with_object({}) do |custom_element, mapping|
            src = custom_element_script_mapping(custom_element)
            mapping[custom_element] = src if src
          end
        end

        # Return all custom library script tags required for the given custom
        # element tags
        # @return [Array[String]]
        def script_tags
          sources.map do |custom_element_tag, src|
            <<-HTML.gsub(/\s+/, ' ').strip
                <script async
                        custom-element="#{custom_element_tag}"
                        src="#{src}"></script>
            HTML
          end
        end

        private

        # Given a custom_element identifier, get the script script source
        # @param [Symbol] custom_element_tag
        # @return [String]
        def custom_element_script_mapping(custom_element_tag)
          {
            'amp-iframe': 'https://cdn.ampproject.org/v0/amp-iframe-0.1.js',
            'amp-twitter': 'https://cdn.ampproject.org/v0/amp-twitter-0.1.js',
            'amp-youtube': 'https://cdn.ampproject.org/v0/amp-youtube-0.1.js',
            'amp-vimeo': 'https://cdn.ampproject.org/v0/amp-vimeo-0.1.js',
            'amp-facebook':
              'https://cdn.ampproject.org/v0/amp-facebook-0.1.js',
            'amp-soundcloud':
              'https://cdn.ampproject.org/v0/amp-soundcloud-0.1.js',
          }[custom_element_tag]
        end
      end
    end
  end
end

