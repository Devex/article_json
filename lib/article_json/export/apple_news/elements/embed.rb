module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Embed < Base
          # Embed| Embed, Caption
          # @return [Hash, Array<Hash>]
          def export
            caption_text.nil? ? embed : [embed, caption]
          end

          private

          # Embed
          # @return [Hash]
          def embed
            {
              role: role,
              URL: source_url,
              caption: caption_text,
            }.compact
          end

          # Caption
          # @return [Hash]
          def caption
            {
              role: 'caption',
              text: caption_text,
              format: 'html',
              layout: 'captionLayout',
              textStyle: 'captionStyle',
            }
          end

          # Get the exporter class for text elements
          # @return [ArticleJSON::Export::Common::HTML::Elements::Base]
          def text_exporter
            self.class.exporter_by_type(:text)
          end

          # Caption Text
          # @return [String]
          def caption_text
            return nil if role.nil? # Do not show captions for unsupported components

            text.empty? ? nil : text
          end

          # @return [String]
          def text
            @element.caption.map do |child_element|
              text_exporter.new(child_element)
                           .export
            end.join
          end

          def role
            @role ||=
              case embed_type
              when :youtube_video, :vimeo_video, :dailymotion_video
                :embedwebvideo
              when :facebook_video
                :facebook_post
              when :tweet
                :tweet
              when :slideshare
                nil
              when :soundcloud
                nil
              else
                nil
              end
          end

          def source_url
            case embed_type
            when :youtube_video
              build_embeded_youtube_url
            when :vimeo_video
              build_embeded_vimeo_url
            when :dailymotion_video
              build_embeded_vimeo_url
            when :facebook_video
              build_facebook_video_url
            when :tweet
              build_twitter_url
            when :slideshare
              nil
            when :soundcloud
              nil
            else
              nil
            end
          end

          def build_embeded_youtube_url
            "https://www.youtube.com/embed/#{embed_id}"
          end

          def build_embeded_vimeo_url
            "https://player.vimeo.com/video/#{embed_id}"
          end

          def build_embeded_dailymotion_url
            "https://geo.dailymotion.com/player.html?video=#{embed_id}"
          end

          def build_facebook_video_url
            username, id = embed_id.to_s.split("/", 2)
            "https://www.facebook.com/#{username}/videos/#{id}"
          end

          def build_twitter_url
            username, id = embed_id.to_s.split("/", 2)
            "https://twitter.com/#{username}/status/#{id}"
          end

          def embed_type
            @embed_type ||= @element.embed_type.to_sym
          end

          def embed_id
            @embed_id ||= @element.embed_id.to_sym
          end
        end
      end
    end
  end
end
