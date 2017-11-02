module ArticleJSON
  module Export
    module AMP
      module Elements
        class Embed < Base
          include ArticleJSON::Export::Common::HTML::Elements::Shared::Caption

          # Generate the embedded element node
          # @return [Nokogiri::XML::NodeSet]
          def export
            create_element(:figure) do |figure|
              figure.add_child(embed_node)
              figure.add_child(caption_node(:figcaption))
            end
          end

          # Custom element tags required for this embedded element
          # @return [Array[Symbol]]
          def custom_element_tags
            case @element.embed_type.to_sym
            when :youtube_video then %i(amp-youtube)
            when :vimeo_video then %i(amp-vimeo)
            when :facebook_video then %i(amp-facebook)
            when :tweet then %i(amp-twitter)
            when :slideshare then %i(amp-iframe)
            else []
            end
          end

          private

          # @return [Nokogiri::XML::Element]
          def embed_node
            create_element(:div, class: 'embed') do |div|
              div.add_child(type_specific_node)
            end
          end

          # @return [Nokogiri::XML::Element|nil]
          def type_specific_node
            case @element.embed_type.to_sym
            when :youtube_video
              youtube_node
            when :vimeo_video
              vimeo_node
            when :facebook_video
              facebook_node
            when :tweet
              tweet_node
            when :slideshare
              slideshare_node
            end
          end

          # @return [Nokogiri::XML::Element]
          def youtube_node
            create_element('amp-youtube',
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          # @return [Nokogiri::XML::Element]
          def vimeo_node
            create_element('amp-vimeo',
                           'data-videoid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          # @return [Nokogiri::XML::Element]
          def tweet_node
            create_element('amp-twitter',
                           'data-tweetid' => @element.embed_id,
                           width: default_width,
                           height: default_height)
          end

          # @return [Nokogiri::XML::Element]
          def facebook_node
            url = "#{@element.oembed_data[:author_url]}videos/#{@element.embed_id}"
            create_element('amp-facebook',
                           'data-embedded-as' => 'video',
                           'data-href' => url,
                           width: default_width,
                           height: default_height)
          end

          # @return [Nokogiri::XML::Element]
          def slideshare_node
            node = Nokogiri::HTML(@element.oembed_data[:html]).xpath('//iframe')
            create_element('amp-iframe',
                           src: node.attribute('src').value,
                           width: node.attribute('width').value,
                           height: node.attribute('height').value,
                           frameborder: '0',)
          end

          # @return [String]
          def default_width
            '560'
          end

          # @return [String]
          def default_height
            '315'
          end
        end
      end
    end
  end
end
