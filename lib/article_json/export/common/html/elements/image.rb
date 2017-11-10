module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Image
            include ArticleJSON::Export::Common::HTML::Elements::Shared::Caption
            include ArticleJSON::Export::Common::HTML::Elements::Shared::Float

            # Generate the `<figure>` node containing the image and caption
            # @return [Nokogiri::XML::Element]
            def export
              create_element(:figure, node_opts) do |figure|
                figure.add_child(image_node)
                if @element.caption&.any?
                  figure.add_child(caption_node(:figcaption))
                end
              end
            end

            private

            # @return [Nokogiri::XML::NodeSet]
            def image_node
              create_element(:img, src: @element.source_url)
            end

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
end
