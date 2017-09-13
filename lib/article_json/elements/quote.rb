module ArticleJSON
  module Elements
    class Quote
      attr_reader :type, :content, :caption, :float

      # @param [Array[ArticleJSON::Elements::Paragraph]] content
      # @param [Array[ArticleJSON::Elements::Text]] caption
      # @param [Symbol] float
      def initialize(content:, caption:, float: nil)
        @type = :quote
        @content = content
        @caption = caption
        @float = float
      end

      # Hash representation of this quote element
      # @return [Hash]
      def to_h
        {
          type: type,
          float: float,
          content: content.map(&:to_h),
          caption: caption.map(&:to_h),
        }
      end
    end
  end
end

