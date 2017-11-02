module ArticleJSON
  module Export
    module AMP
      class Exporter
        include ArticleJSON::Export::Common::HTML::Exporter

        # List of all used custom element tags, e.g. `[:'amp-iframe']`
        # @return [Array[Symbol]]
        def custom_element_tags
          return @custom_element_tags if defined? @custom_element_tags
          @custom_element_tags =
            element_exporters
              .flat_map { |element| element.custom_element_tags }
              .uniq
        end

        # Return an array with all the javascript libraries needed for some
        # special AMP tags (like amp-facebook or amp-iframe)
        # @return [Array<String>]
        def amp_libraries
          return @amp_libraries if defined? @amp_libraries
          @amp_libraries =
            CustomElementLibraryResolver.new(custom_element_tags).script_tags
        end

        class << self
          # Return the module namespace this class is nested in
          # @return [Module]
          def namespace
            ArticleJSON::Export::AMP
          end
        end
      end
    end
  end
end
