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

          def type_specific_node
            case @element.embed_type
            when :youtube_video
              youtube_node
            when :vimeo_video
              vimeo_node
            when :facebook_video
              facebook_node
            end
          end

          def youtube_node
            create_element('amp-youtube',
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          def vimeo_node
            create_element('amp-vimeo',
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          def facebook_node
            url = "#{@element.oembed_data[:author_url]}videos/#{@element.embed_id}"
            create_element('amp-facebook',
                           'data-embedded-as' => 'video',
                           'data-href' => url,
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
