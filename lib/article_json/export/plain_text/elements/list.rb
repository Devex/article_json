module ArticleJSON
  module Export
    module PlainText
      module Elements
        class List < Base
          # List of strings, one per line. If the list type is "ordered" then
          # each line is preceded with a number, otherwise a dash. Newlines
          # within a list item are indented accordingly.
          # @return [String]
          def export
            "#{list}\n"
          end

          private

          # Plain-text list of items using the right prefix
          # @return [String]
          def list
            @element
              .content
              &.each_with_index
              &.map do |content, index|
                "#{prefix(index)} #{paragraph_exporter.new(content).export}"
                  .gsub(/\n(?!$)/, newline_with_indention)
              end&.join || ''
          end

          # Prefix used for every list item
          # @param [String] index
          def prefix(index)
            @element.list_type == :ordered ? "#{index + 1}." : '-'
          end

          # Newline followed by the right amount of spaces to align with the
          # indentation from the prefix
          # @return [String]
          def newline_with_indention
            "\n " + ' ' * prefix(0).length
          end

          # Get the exporter class for paragraph elements
          # @return [ArticleJSON::Export::Common::HTML::Elements::Base]
          def paragraph_exporter
            self.class.exporter_by_type(:paragraph)
          end
        end
      end
    end
  end
end
