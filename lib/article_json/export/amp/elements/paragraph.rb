module ArticleJSON
  module Export
    module AMP
      module Elements
        class Paragraph < Base
          def export
            create_element(:p).tap do |p|
              @element.content.each do |child_element|
                p.add_child(Text.new(child_element).export)
              end
            end
          end
        end
      end
    end
  end
end
