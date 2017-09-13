module ArticleJSON
  module Elements
    class List
      attr_reader :type, :content, :list_type

      # @param [Array[ArticleJSON::Elements::Paragraph]] content
      # @param [Symbol] list_type
      def initialize(content:, list_type: :unordered)
        @type = :list
        @content = content
        @list_type = list_type
      end

      # Hash representation of this heading element
      # @return [Hash]
      def to_h
        {
          type: type,
          list_type: list_type,
          content: content.map(&:to_h),
        }
      end
    end
  end
end

