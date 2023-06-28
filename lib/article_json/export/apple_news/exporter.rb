module ArticleJSON
  module Export
    module AppleNews
      class Exporter
        # @param [Array[ArticleJSON::Elements::Base]] elements
        def initialize(elements)
          @elements = elements
        end

        # Return the components section of an Apple News Article as JSON
        #
        # Images and EmbededVideos are nested in an array with the components
        # array when they contain captions. As Apple News skips over these
        # nested arrays, we must flatten the array.
        #
        # @return [String]
        def to_json
          { components: components.flatten }.to_json
        end

        private

        # Generate an array with the plain text representation of all elements
        # 
        # @return [Array]
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
