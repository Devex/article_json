module ArticleJSON
  module Elements
    class Embed < Base
      attr_reader :embed_type, :embed_id, :caption, :tags

      # @param [Symbol] embed_type
      # @param [String] embed_id
      # @param [Array[ArticleJSON::Elements::Text]] caption
      # @param [Array] tags
      def initialize(embed_type:, embed_id:, caption:, tags: [])
        @type = :embed
        @embed_type = embed_type
        @embed_id = embed_id
        @caption = caption
        @tags = tags
      end

      # Hash representation of this embedded element
      # @return [Hash]
      def to_h
        {
          type: type,
          embed_type: embed_type,
          embed_id: embed_id,
          tags: tags,
          caption: caption.map(&:to_h),
        }
      end

      # Obtain the oembed data for this embed element
      # @return [Hash|nil]
      def oembed_data
        oembed_resolver&.oembed_data
      end

      # @return [Array[ArticleJSON::Elements::Text]|nil]
      def oembed_unavailable_message
        oembed_resolver&.unavailable_message
      end

      private

      # @return [ArticleJSON::Utils::OEmbedResolver::Base]
      def oembed_resolver
        @oembed_resolver ||=
          ArticleJSON::Utils::OEmbedResolver::Base.build(self)
      end

      class << self
        # Create an embedded element from Hash
        # @return [ArticleJSON::Elements::Embed]
        def parse_hash(hash)
          new(
            embed_type: hash[:embed_type],
            embed_id: hash[:embed_id],
            caption: parse_hash_list(hash[:caption]),
            tags: hash[:tags]
          )
        end
      end
    end
  end
end
