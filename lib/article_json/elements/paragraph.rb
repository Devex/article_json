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

