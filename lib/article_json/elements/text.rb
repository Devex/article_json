module ArticleJSON
  module Elements
    class Text
      attr_reader :type, :content, :bold, :italic, :href

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
    end
  end
end

