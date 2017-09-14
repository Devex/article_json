module ArticleJSON
  module Elements
    class Heading < Base
      attr_reader :level, :content

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

      class << self
        # Create a heading element from Hash
        # @return [ArticleJSON::Elements::Heading]
        def parse_hash(hash)
          new(
            level: hash[:level].to_i,
            content: hash[:content]
          )
        end
      end
    end
  end
end

