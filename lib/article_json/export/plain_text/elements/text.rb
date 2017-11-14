module ArticleJSON
  module Export
    module PlainText
      module Elements
        class Text < Base
          # Text is just returned plain, no formatting or linking is taken into
          # account.
          # @return [String]
          def export
            @element.content
          end
        end
      end
    end
  end
end
