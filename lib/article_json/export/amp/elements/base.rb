module ArticleJSON
  module Export
    module AMP
      module Elements
        class Base
          include ArticleJSON::Export::Common::HTML::Elements::Base

          # List of custom element tags used by this element
          # @return [Array[Symbol]]
          def custom_element_tags
            []
          end

          class << self
            # Return the module namespace this class and its subclasses are
            # nested in
            # @return [Module]
            def namespace
              ArticleJSON::Export::AMP::Elements
            end

            private

            # The format this exporter is returning. This is used to determine
            # which custom element exporters should be applied from the
            # configuration.
            # @return [Symbol]
            def export_format
              :amp
            end
          end
        end
      end
    end
  end
end
