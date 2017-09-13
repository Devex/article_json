module ArticleJSON
  module Elements
    class TextBox
      attr_reader :type, :content, :float

      # @param [Array[Paragraph|Heading|List]] content
      # @param [Symbol] float
      def initialize(content:, float: nil)
        @type = :text_box
        @content = content
        @float = float
      end

      # Hash representation of this text box element
      # @return [Hash]
      def to_h
        {
          type: type,
          float: float,
          content: content.map(&:to_h),
        }
      end
    end
  end
end

