module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedTweetElement < EmbeddedParser
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :tweet
          end

          # Extract the tweet ID (including the handle) from an URL
          # @return [String]
          def embed_id
            match = @node.inner_text.strip.match(self.class.url_regexp)
            "#{match[:handle]}/#{match[:id]}" if match
          end

          class << self
            # Regular expression to check if a given string is a Twitter URL
            # Also used to extract the ID from the URL.
            # @return [Regexp]
            def url_regexp
              %r{
                ^\S*                        # all protocols & sub domains
                twitter\.com/               # domain
                (?<handle>[^#/]+)           # twitter handle
                (?:\#|/status/|/statuses/)  # optional path or hash char
                (?<id>\d+)                  # numeric tweet id
              }xi
            end
          end
        end
      end
    end
  end
end
