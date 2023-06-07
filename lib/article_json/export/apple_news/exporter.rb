module ArticleJSON
  module Export
    module AppleNews
      class Exporter
        # @param [Array[ArticleJSON::Elements::Base]] elements
        def initialize(elements)
          @elements = elements
        end

        # Return the components section of an Apple News Article as JSON
        # @return [String]
        def to_json
          { components: components }.to_json
        end

        private

        # Generate a string with the plain text representation of all elements
        # @return [String]
        def components
          @components ||=
            @elements.map do |element|
              ArticleJSON::Export::AppleNews::Elements::Base
                .build(element)
                &.export
            end.reject { |hash| hash.nil? || hash.empty? }
        end
      end
    end
  end
end
