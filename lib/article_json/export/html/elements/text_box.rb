module ArticleJSON
  module Export
    module HTML
      module Elements
        class TextBox < Base
          include Shared::Float

          def export
            create_element(:div, node_opts).tap do |div|
              @element.content.each do |child_element|
                div.add_child(Base.new(child_element).export)
              end
            end
          end

          private

          def node_opts
            { class: ['text-box', floating_class].compact.join(' ') }
          end
        end
      end
    end
  end
end
