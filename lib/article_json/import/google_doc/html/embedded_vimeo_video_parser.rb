module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedVimeoVideoParser < EmbeddedParser
          # The type of this embedded element
          # @return [Symbol]
          def embed_type
            :vimeo_video
          end

          class << self
            # Regular expression to check if a given string is a Vimeo URL
            # Can also be used to extract the ID from the URL
            # @return [Regexp]
            def url_regexp
              %r{
                ^\S*                # all protocols & sub domains
                vimeo\.com          # domain
                .*([\#/]|clip_id=)  # optional path & param
                (?<id>[\d]+)        # numerical id
              }xi
            end
          end
        end
      end
    end
  end
end
