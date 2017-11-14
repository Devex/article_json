module ArticleJSON
  module Export
    module PlainText
      module Elements
        class TextBox < Base
          # Text boxes are being skipped when rendering plain text. Therefore,
          # return an empty string.
          # @return [String]
          def export
            ''
          end
        end
      end
    end
  end
end
