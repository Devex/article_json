module ArticleJSON
  module Export
    module PlainText
      module Elements
        class Base
          include ArticleJSON::Export::Common::Elements::Base

          # Export the given element. Dynamically looks up the right
          # export-element-class, instantiates it and then calls the `#export`
          # method.
          # Defaults to an empty string, e.g. if no exporter is specified for
          # the given type.
          # @return [String]
          def export
            super || ''
          end

          class << self
            # Return the module namespace this class and its subclasses are
            # nested in
            # @return [Module]
            def namespace
              ArticleJSON::Export::PlainText::Elements
            end

            private

            # The format this exporter is returning. This is used to determine
            # which custom element exporters should be applied from the
            # configuration.
            # @return [Symbol]
            def export_format
              :plain_text
            end

            def default_exporter_mapping
              {
                text: namespace::Text,
                paragraph: namespace::Paragraph,
                heading: namespace::Heading,
                list: namespace::List,
                quote: namespace::Quote,
                image: nil,
                embed: nil,
                text_box: nil,
              }
            end
          end
        end
      end
    end
  end
end
