module ArticleJSON
  module Export
    module AMP
      module Elements
        class Quote < Base
          include Shared::Caption
          include Shared::Float

          def export
            create_element(:div, node_opts).tap do |div|
              @element.content.each do |child_element|
                div.add_child(Base.new(child_element).export)
              end
              div.add_child(caption_node(:small))
            end
          end

          private

          # @return [Hash]
          def node_opts
            { class: ['quote', floating_class].compact.join(' ') }
          end
        end
      end
    end
  end
end
