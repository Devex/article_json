module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Heading < Base
          # Headline
          # @return [Hash]
          def export
            {
              role: role,
              text: @element.content,
              layout: 'titleLayout',
              textStyle: 'defaultTitle',
            }
          end

          private

          # The role of text component for adding a heading. (Required) Always
          # one of these roles for this component: heading, heading1, heading2,
          # heading3, heading4, heading5, or heading6.
          # @return [String]
          def role
            return 'heading' if @element.level.nil?

            "heading#{@element.level}"
          end
        end
      end
    end
  end
end
