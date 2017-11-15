module ArticleJSON
  module Elements
    class Text < Base
      attr_reader :content, :bold, :italic, :href

      # @param [String] content
      # @param [Boolean] bold
      # @param [Boolean] italic
      # @param [String] href
      def initialize(content:, bold: false, italic: false, href: nil)
        @type = :text
        @content = content
        @bold = bold
        @italic = italic
        @href = href
      end

      # Hash representation of this text node
      # @return [Hash]
      def to_h
        {
          type: type,
          content: content,
          bold: bold,
          italic: italic,
          href: href,
        }
      end

      # Returns `true` if `content` has a length of zero or is `nil`
      # @return [Boolean]
      def empty?
        !content || content.empty?
      end

      # Returns `true` if `content` is empty (see `#empty?`) or only contains
      # whitespace (including non-breaking whitespace) characters
      # @return [Boolean]
      def blank?
        empty? || content.gsub(/[\s\u00A0]/, '').empty?
      end

      # Get the number of characters contained by this text element
      # @return [Integer]
      def length
        return 0 if blank?
        content.length
      end
      alias size length

      class << self
        # Create a text element from Hash
        # @return [ArticleJSON::Elements::Text]
        def parse_hash(hash)
          new(
            content: hash[:content],
            bold: hash[:bold],
            italic: hash[:italic],
            href: hash[:href]
          )
        end
      end
    end
  end
end

