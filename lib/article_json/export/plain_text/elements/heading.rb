module ArticleJSON
  module Export
    module PlainText
      module Elements
        class Heading < Base
          # Headline separated by newlines
          # @return [String]
          def export
            "#{leading_newlines}#{@element.content}\n\n"
          end

          private

          # String with dynamic number of newlines, depending on heading level.
          # @return [String]
          def leading_newlines
            case @element.level
            when 1 then "\n\n\n"
            when 2 then "\n\n"
            else "\n"
            end
          end
        end
      end
    end
  end
end
