module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Quote < Base
          include ArticleJSON::Export::Common::HTML::Elements::Quote

          private

          # @return [Hash]
          def node_opts
            {}
          end

          # HTML tag for the wrapping node
          # @return [Symbol]
          def quote_tag
            :aside
          end

          # HTML tag for the node containing the caption
          # @return [Symbol]
          def caption_tag
            :cite
          end
        end
      end
    end
  end
end
