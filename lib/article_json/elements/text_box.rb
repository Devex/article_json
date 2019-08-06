module ArticleJSON
  module Elements
    class TextBox < Base
      attr_reader :content, :float, :tags

      # @param [Array[Paragraph|Heading|List]] content
      # @param [Symbol] float
      # @param [Array] tags
      def initialize(content:, float: nil, tags: [])
        @type = :text_box
        @content = content
        @float = float
        @tags = tags
      end

      # Hash representation of this text box element
      # @return [Hash]
      def to_h
        {
          type: type,
          float: float,
          content: content.map(&:to_h),
          tags: tags,
        }
      end

      class << self
        # Create a text box element from Hash
        # @return [ArticleJSON::Elements::TextBox]
        def parse_hash(hash)
          new(
            content: parse_hash_list(hash[:content]),
            float: hash[:float]&.to_sym,
            tags: hash[:tags]
          )
        end
      end
    end
  end
end

