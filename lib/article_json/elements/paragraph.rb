module ArticleJSON
  module Elements
    class Paragraph
      attr_reader :type, :content

      # @param [Array[ArticleJSON::Elements::Text]] content
      def initialize(content:)
        @type = :paragraph
        @content = content
      end

      # Hash representation of this heading element
      # @return [Hash]
      def to_h
        {
          type: type,
          content: content.map(&:to_h),
        }
      end
    end
  end
end

