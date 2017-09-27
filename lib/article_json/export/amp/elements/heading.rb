module ArticleJSON
  module Export
    module AMP
      module Elements
        class Heading < Base
          def export
            create_element(tag_name, @element.content)
          end

          private

          def tag_name
            "h#{@element.level}".to_sym
          end
        end
      end
    end
  end
end
