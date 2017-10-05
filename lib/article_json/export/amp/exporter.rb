module ArticleJSON
  module Export
    module AMP
      class Exporter
        # @param [Array[ArticleJSON::Elements::Base]] elements
        def initialize(elements)
          @elements = elements
          @amp_libraries = Set.new
        end

        # Generate a string with the HTML representation of all elements
        # @return [String]
        def html
          doc = Nokogiri::HTML.fragment('')
          @elements.each do |element|
            doc.add_child(Elements::Base.new(element).export)
          end
          doc.to_html(save_with: 0)
        end

        # Return an array with all the javascript libraries needed for some especial
        # AMP tags (like amp-facebook or amp-iframe)
        # @return [Array<String>]
        def amp_libraries
          @elements.each do |element|
            exporter = Elements::Base.build(element)
            next unless exporter.is_a? ArticleJSON::Export::AMP::Elements::Embed
            @amp_libraries.add exporter.amp_library if exporter.amp_library
          end
          @amp_libraries.to_a
        end
      end
    end
  end
end
