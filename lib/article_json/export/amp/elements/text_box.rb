module ArticleJSON
  module Export
    module AMP
      module Elements
        class TextBox < Base
          include Shared::Float

          # Generate a `<div>` node containing all text box elements
          # return [Nokogiri::XML::NodeSet]
          def export
            create_element(:div, node_opts) do |div|
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
