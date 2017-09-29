module ArticleJSON
  module Export
    module AMP
      module Elements
        class Quote < Base
          include Shared::Caption
          include Shared::Float

          def export
            create_element(:aside, node_opts).tap do |aside|
              @element.content.each do |child_element|
                aside.add_child(Base.new(child_element).export)
              end
              aside.add_child(caption_node(:small))
            end
          end

          private

          # @return [Hash]
          def node_opts
            return if floating_class.nil?
            { class: floating_class }
          end
        end
      end
    end
  end
end
