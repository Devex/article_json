module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module TextBox
            include ArticleJSON::Export::Common::HTML::Elements::Shared::Float

            # Generate a `<div>` node containing all text box elements
            # @return [Nokogiri::XML::NodeSet]
            def export
              create_element(:div, node_opts) do |div|
                @element.content.each do |child_element|
                  div.add_child(base_class.new(child_element).export)
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
end
