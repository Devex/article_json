module ArticleJSON
  module Export
    module HTML
      module Elements
        class Paragraph < Base
          def build
            create_element(:p).tap do |p|
              @element.content.each do |child_element|
                p.add_child(Text.new(child_element).build)
              end
            end
          end
        end
      end
    end
  end
end
