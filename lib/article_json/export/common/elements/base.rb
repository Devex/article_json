module ArticleJSON
  module Export
    module Common
      module Elements
        module Base
          # Extend `base` class with `ClassMethods` upon inclusion
          def self.included(base)
            base.extend ClassMethods
          end

          # @param [ArticleJSON::Elements::Base] element
          def initialize(element)
            @element = element
          end

          # Export the given element. Dynamically looks up the right
          # export-element-class, instantiates it and then calls the `#export`
          # method.
          # @return [Object]
          def export
            exporter.export unless exporter.nil?
          end

          private

          # Get the right exporter class for the given element
          # @return [ArticleJSON::Export::Common::Elements::Base]
          def exporter
            @exporter ||=
              self.class.base_class? ? self.class.build(@element) : self
          end

          # Return the base class for the current element instance
          # @return [ArticleJSON::Export::Common::Elements::Base]
          def base_class
            self.class.namespace::Base
          end

          module ClassMethods
            # Instantiate the correct sub class for a given element
            # @param [ArticleJSON::Elements::Base] element
            # @return [ArticleJSON::Export::Common::Elements::Base]
            def build(element)
              klass = exporter_by_type(element.type)
              klass.new(element) unless klass.nil?
            end

            # Look up the correct exporter class based on the element type
            # @param [Symbol] type
            # @return [ArticleJSON::Export::Common::Elements::Base]
            def exporter_by_type(type)
              key = type.to_sym
              custom_class = ArticleJSON.configuration.element_exporter_for(
                export_format, key
              )
              custom_class || default_exporter_mapping[key]
            end

            # Check if the current class is the base class a child class.
            # Since this common module is in a different namespace, a simple
            # `self == Base` check does not work.
            # @return [Boolean]
            def base_class?
              self == namespace::Base
            end

            def default_exporter_mapping
              {
                text: namespace::Text,
                paragraph: namespace::Paragraph,
                heading: namespace::Heading,
                list: namespace::List,
                quote: namespace::Quote,
                image: namespace::Image,
                embed: namespace::Embed,
                text_box: namespace::TextBox,
              }
            end
          end
        end
      end
    end
  end
end
