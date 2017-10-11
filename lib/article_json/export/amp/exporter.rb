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
          amp_elements.each do |exported_element|
            doc.add_child(exported_element.export)
          end
          doc.to_html(save_with: 0)
        end

        def custom_element_tags
          return @custom_element_tags if defined? @custom_element_tags
          @custom_element_tags =
            amp_elements.flat_map { |element| element.custom_element_tags }.uniq
        end

        # Return an array with all the javascript libraries needed for some
        # special AMP tags (like amp-facebook or amp-iframe)
        # @return [Array<String>]
        def amp_libraries
          return @amp_libraries if defined? @amp_libraries
          @amp_libraries =
            CustomElementLibraryResolver.new(custom_element_tags).script_tags
        end

        private

        def amp_elements
          @amp_elements ||= @elements.map { |e| Elements::Base.build(e) }
        end
      end
    end
  end
end
