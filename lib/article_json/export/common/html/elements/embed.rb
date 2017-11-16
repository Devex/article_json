module ArticleJSON
  module Export
    module Common
      module HTML
        module Elements
          module Embed
            include ArticleJSON::Export::Common::HTML::Elements::Shared::Caption

            # Generate the embedded element node
            # @return [Nokogiri::XML::NodeSet]
            def export
              create_element(:figure) do |figure|
                figure.add_child(embed_node)
                if @element.caption&.any?
                  figure.add_child(caption_node(:figcaption))
                end
              end
            end

            private

            def embed_node
              type = @element.embed_type.to_s.tr('_','-')
              create_element(:div, class: "embed #{type}") do |div|
                div.add_child(embedded_object)
              end
            end

            def embedded_object
              return unavailable_node unless @element.oembed_data
              Nokogiri::HTML.fragment(@element.oembed_data[:html])
            end

            def unavailable_node
              create_element(:span, class: 'unavailable-embed') do |span|
                @element.oembed_unavailable_message.each do |element|
                  span.add_child(base_class.build(element).export)
                end
              end
            end
          end
        end
      end
    end
  end
end
