module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Quote
            include ArticleJSON::Export::Common::HTML::Elements::Shared::Caption
            include ArticleJSON::Export::Common::HTML::Elements::Shared::Float

            # Generate the quote node with all its containing text elements
            # @return [Nokogiri::XML::NodeSet]
            def export
              create_element(quote_tag, node_opts) do |div|
                @element.content.each do |child_element|
                  div.add_child(base_class.new(child_element).export)
                end
                if @element.caption&.any?
                  div.add_child(caption_node(caption_tag))
                end
              end
            end

            private

            # @return [Hash]
            def node_opts
              { class: ['quote', floating_class].compact.join(' ') }
            end

            # HTML tag for the wrapping node
            # @return [Symbol]
            def quote_tag
              :div
            end

            # HTML tag for the node containing the caption
            # @return [Symbol]
            def caption_tag
              :small
            end
          end
        end
      end
    end
  end
end
