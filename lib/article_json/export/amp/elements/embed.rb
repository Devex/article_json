module ArticleJSON
  module Export
    module AMP
      module Elements
        class Embed < Base
          include Shared::Caption

          def export
            create_element(:figure).tap do |figure|
              figure.add_child(embed_node)
              figure.add_child(caption_node(:figcaption))
            end
          end

          private

          def embed_node
            create_element(:div, class: 'embed').tap do |div|
              div.add_child(type_specific_node)
            end
          end

          def amp_tag
            {
              vimeo_video: 'amp-vimeo',
              youtube_video: 'amp-youtube',
            }[@element.embed_type.to_sym]
          end

          def type_specific_node
            create_element(amp_tag,
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          def default_width
            '560'
          end

          def default_height
            '315'
          end
        end
      end
    end
  end
end
