module ArticleJSON
  module Elements
    class Paragraph < Base
      attr_reader :content

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

      # Return `true` if the paragraph has no elements
      # @return [Boolean]
      def empty?
        !content || content.empty?
      end

      # Return `true` if the paragraph is empty or if all elements are blank
      # @return [Boolean]
      def blank?
        empty? || content.all? do |element|
          element.respond_to?(:blank?) && element.blank?
        end
      end

      # Return the sum of all characters within the content's text elements
      # @return [Integer]
      def length
        return 0 if empty?
        @content.reduce(0) do |sum, element|
          sum + (element.respond_to?(:length) ? element.length : 0)
        end
      end
      alias size length

      class << self
        # Create a paragraph element from Hash
        # @return [ArticleJSON::Elements::Paragraph]
        def parse_hash(hash)
          new(content: parse_hash_list(hash[:content]))
        end
      end
    end
  end
end

