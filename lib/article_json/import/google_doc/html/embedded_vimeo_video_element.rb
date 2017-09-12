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

          class << self
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
