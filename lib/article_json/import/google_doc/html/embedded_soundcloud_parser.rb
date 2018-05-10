module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedSoundcloudParser < EmbeddedParser
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :soundcloud
          end

          class << self
            # Regular expression to check if a given string is a Soundcloud URL
            # Also used to extract the ID from the URL.
            # @return [Regexp]
            def url_regexp
              %r{
                ^\S*                    # all protocols & sub domains
                soundcloud\.com/        # domain
                (?<id>[-/0-9a-z]+)      # the slug of the user / track
              }xi
            end
          end
        end
      end
    end
  end
end
