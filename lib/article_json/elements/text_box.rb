module ArticleJSON
  module Elements
    class TextBox < Base
      attr_reader :content, :float

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

      class << self
        # Create a text box element from Hash
        # @return [ArticleJSON::Elements::TextBox]
        def parse_hash(hash)
          new(
            content: parse_hash_list(hash[:content]),
            float: hash[:float]&.to_sym
          )
        end
      end
    end
  end
end

