module ArticleJSON
  module Export
    module HTML
      module Elements
        class Embed < Base
          include Shared::Caption

          def build
            create_element(:figure).tap do |figure|
              figure.add_child(embed_node)
              figure.add_child(caption_node(:figcaption))
            end
          end

          private

          def embed_node
            create_element(:div, embedded_object, class: 'embed')
          end

          def embedded_object
            "Embedded Object: #{@element.embed_type}-#{@element.embed_id}"
          end
        end
      end
    end
  end
end
