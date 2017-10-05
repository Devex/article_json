module ArticleJSON
  module Export
    module AMP
      class Exporter
        # @param [Array[ArticleJSON::Elements::Base]] elements
        def initialize(elements)
          @elements = elements
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
      end
    end
  end
end
