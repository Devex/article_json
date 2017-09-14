module ArticleJSON
  module Elements
    class List < Base
      attr_reader :content, :list_type

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

      class << self
        # Create a list element from Hash
        # @return [ArticleJSON::Elements::List]
        def parse_hash(hash)
          new(
            content: parse_hash_list(hash[:content]),
            list_type: hash[:list_type].to_sym
          )
        end
      end
    end
  end
end

