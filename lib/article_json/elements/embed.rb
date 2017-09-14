module ArticleJSON
  module Elements
    class Embed
      attr_reader :type, :embed_type, :embed_id, :caption, :tags

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
    end
  end
end

