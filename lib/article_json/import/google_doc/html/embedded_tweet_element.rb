module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedTweetElement < EmbeddedElement
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :tweet
          end

          # Extract the tweet ID (including the handle) from an URL
          # @return [String]
          def embed_id
            match = @node.inner_text.strip.match(self.class.url_regexp)
            "#{match[1]}/#{match[2]}" if match
          end

          class << self
            # Regular expression to check if a given string is a Twitter URL
            # Also used to extract the ID from the URL.
            # @return [Regexp]
            def url_regexp
              %r(^\S*twitter\.com/?([^#/]+)(?:#|/status/|/statuses/)?(\d+))i
            end
          end
        end
      end
    end
  end
end
