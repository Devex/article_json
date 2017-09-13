module ArticleJSON
  module Elements
    class Image
      attr_reader :type, :source_url, :caption, :float

      # @param [String] source_url
      # @param [Array[ArticleJSON::Elements::Text]] caption
      # @param [Symbol] float
      def initialize(source_url:, caption:, float: nil)
        @type = :image
        @source_url = source_url
        @caption = caption
        @float = float
      end

      # Hash representation of this image element
      # @return [Hash]
      def to_h
        {
          type: type,
          source_url: source_url,
          float: float,
          caption: caption.map(&:to_h),
        }
      end
    end
  end
end

