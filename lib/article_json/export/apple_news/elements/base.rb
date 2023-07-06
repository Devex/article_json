module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Base
          include ArticleJSON::Export::Common::Elements::Base

          # Export the given element. Dynamically looks up the right
          # export-element-class, instantiates it and then calls the `#export`
          # method.
          # Defaults to nil, e.g. if no exporter is specified for the given
          # type.
          # @return [String]
          def export
            super || nil
          end

          class << self
            # Return the module namespace this class and its subclasses are
            # nested within.
            # @return [Module]
            def namespace
              ArticleJSON::Export::AppleNews::Elements
            end

            private

            # The format this exporter is returning. This is used to determine
            # which custom element exporters should be applied from the
            # configuration.
            # @return [Symbol]
            def export_format
              :apple_news
            end

            def default_exporter_mapping
              {
                text: namespace::Text,
                paragraph: namespace::Paragraph,
                heading: namespace::Heading,
                quote: namespace::Quote,
                list: namespace::List,
                image: namespace::Image,
                embed: namespace::Embed,
                text_box: nil
              }
            end
          end
        end
      end
    end
  end
end
