module ArticleJSON
  module Export
    module AMP
      module Elements
        class Image < Base
          include ArticleJSON::Export::Common::HTML::Elements::Image

          private

          # @return [Nokogiri::HTML::NodeSet]
          def image_node
            create_element('amp-img',
                           src: @element.source_url,
                           width: default_width,
                           height: default_height,
                           layout: :responsive)
          end

          def default_width
            '640'
          end

          def default_height
            '480'
          end
        end
      end
    end
  end
end
