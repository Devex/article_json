module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedSlideshareElement < EmbeddedElement
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :slideshare
          end

          # Extract the slide show ID (including the handle) from an URL
          # @return [String]
          def embed_id
            match = @node.inner_text.strip.match(self.class.url_regexp)
            "#{match[:handle]}/#{match[:id]}" if match
          end

          class << self
            # Regular expression to check if a given string is a Slideshare URL
            # Also used to extract HANDLE and ID from the URL.
            # @return [Regexp]
            def url_regexp
              %r{
                ^\S*slideshare\.net\/
                (?<handle>[^\/\s]+)\/
                (?<id>[^\/?&\s\u00A0]+)
              }xi
            end
          end
        end
      end
    end
  end
end
