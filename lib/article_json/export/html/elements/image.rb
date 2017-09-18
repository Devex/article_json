module ArticleJSON
  module Export
    module HTML
      module Elements
        class Image < Base
          include Shared::Caption
          include Shared::Float

          # @return [Nokogiri::HTML::Node]
          def build
            create_element(:figure, node_opts).tap do |figure|
              figure.add_child(image_node)
              figure.add_child(caption_node(:figcaption))
            end
          end

          private

          # @return [Nokogiri::HTML::Node]
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
