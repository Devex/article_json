module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Embed < Base
          include ArticleJSON::Export::Common::HTML::Elements::Shared::Caption

          # Generate the embedded element node
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(:figure, class: 'op-interactive') do |figure|
              figure.add_child(embed_node)
              if @element.caption&.any?
                figure.add_child(caption_node(:figcaption))
              end
            end
          end

          private

          # Type specific object that should be embedded
          # @return [Nokogiri::XML::Element]
          def embed_node
            if %i(facebook_video tweet).include? @element.embed_type.to_sym
              iframe_node
            else
              embedded_object
            end
          end

          def iframe_node
            create_element(:iframe) do |div|
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
