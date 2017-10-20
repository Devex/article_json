module ArticleJSON
  module Export
    module HTML
      module Elements
        class Embed < Base
          include Shared::Caption

          # Generate the embedded element node
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(:figure) do |figure|
              figure.add_child(embed_node)
              figure.add_child(caption_node(:figcaption))
            end
          end

          private

          def embed_node
            create_element(:div, class: 'embed') do |div|
              div.add_child(embedded_object)
            end
          end

          def embedded_object
            Nokogiri::HTML.fragment(@element.oembed_data[:html])
          end
        end
      end
    end
  end
end
