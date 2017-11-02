module ArticleJSON
  module Export
    module AMP
      module Elements
        class Quote < Base
          include ArticleJSON::Export::Common::HTML::Elements::Shared::Caption
          include ArticleJSON::Export::Common::HTML::Elements::Shared::Float

          # Generate the quote node with all its containing text elements
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(:div, node_opts) do |div|
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
