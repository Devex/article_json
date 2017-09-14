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

