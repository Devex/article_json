module ArticleJSON
  module Export
    module Common
      module HTML
        module Exporter
          # @param [Array[ArticleJSON::Elements::Base]] elements
          def initialize(elements)
            @elements = elements
          end

          # Generate a string with the HTML representation of all elements
          # @return [String]
          def html
            doc = Nokogiri::HTML.fragment('')
            element_exporters.each do |element_exporter|
              doc.add_child(element_exporter.export)
            end
            doc.to_html(save_with: 0)
          end

          private

          def element_exporters
            @element_exporters ||=
              @elements.map { |e| self.class.namespace::Elements::Base.build(e) }
          end
        end
      end
    end
  end
end
