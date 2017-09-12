module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedVimeoVideoElement < EmbeddedElement
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :vimeo_video
          end

          # Extract the video ID from an URL
          # @return [String]
          def embed_id
            match = @node.inner_text.strip.match(self.class.url_regexp)
            match[1] if match
          end

          class << self
            # Check if a given string is a Vimeo embedding
            # @param [String] text
            # @return [Boolean]
            def matches?(text)
              !!(url_regexp =~ text)
            end

            # Regular expression to check if a given string is a Vimeo URL
            # Can also be used to extract the ID from the URL
            # @return [Regexp]
            def url_regexp
              %r(^\S*vimeo.com/(?:.*#|.*/)?([0-9]+))i
            end
          end
        end
      end
    end
  end
end
