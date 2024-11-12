module ArticleJSON
  module Elements
    class Quote < Base
      attr_reader :content, :caption, :float

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

      class << self
        # Create a quote element from Hash
        # @return [ArticleJSON::Elements::Quote]
        def parse_hash(hash)
          new(
            content: parse_hash_list(hash[:content]),
            caption: parse_hash_list(hash[:caption]),
            float: hash[:float]&.to_sym
          )
        end
      end
    end
  end
end
