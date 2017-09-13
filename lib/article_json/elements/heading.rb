module ArticleJSON
  module Elements
    class Heading
      attr_reader :type, :level, :content
      # @param [String] level
      # @param [String] content
      def initialize(level:, content:)
        @level = level
        @content = content
        @type = :heading
      end

      # Hash representation of this heading element
      # @return [Hash]
      def to_h
        {
          type: type,
          level: level,
          content: content,
        }
      end
    end
  end
end

