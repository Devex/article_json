module ArticleJSON
  module Export
    module PlainText
      class Exporter
        # @param [Array[ArticleJSON::Elements::Base]] elements
        def initialize(elements)
          @elements = elements
        end

        # Generate a string with the plain text representation of all elements
        # @return [String]
        def text
          @text ||=
            @elements.map do |element|
              ArticleJSON::Export::PlainText::Elements::Base
                .build(element)
                &.export
            end.join.strip
        end
      end
    end
  end
end
