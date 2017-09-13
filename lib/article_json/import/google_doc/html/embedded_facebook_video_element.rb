module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedFacebookVideoElement < EmbeddedParser
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :facebook_video
          end

          class << self
            # Regular expression to check if a given string is a FB Video URL
            # Also used to extract the ID from the URL
            # @return [Regexp]
            def url_regexp
              %r{
                ^\S*                        # all protocols & sub domains
                facebook\.com/              # domain
                (                           # optional path & parameters
                  \w+/videos/|
                  video\.php\?v=|
                  video\.php\?id=
                )
                (?<id>\d+)                  # numeric video id
              }xi
            end
          end
        end
      end
    end
  end
end
