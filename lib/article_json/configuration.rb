module ArticleJSON
  ## Add configuration access and block to main module
  class << self
    attr_accessor :configuration

    # @return [ArticleJSON::Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  class Configuration
    attr_accessor :oembed_user_agent

    def initialize
      @oembed_user_agent = nil
      @custom_element_exporters = {}
    end

    # Register a new HTML element exporter or overwrite existing ones.
    # @param [Symbol] type
    # @param [Class] klass
    # @deprecated Use `#register_element_exporters_for(:html, ...)` instead
    def register_html_element_exporter(type, klass)
      register_element_exporters(:html, type => klass)
    end

    # Return custom HTML exporters
    # @return [Hash[Symbol => Class]]
    # @deprecated use `#exporter_for` instead
    def html_element_exporters
      @custom_element_exporters[:html] || {}
    end

    # Set custom HTML exporters
    # @param [Hash[Symbol => Class]] value
    # @deprecated use `#register_element_exporters(:html, ...)` instead
    def html_element_exporters=(value)
      @custom_element_exporters[:html] = value
    end

    # Register new element exporters or overwrite existing ones for a given
    # exporter type.
    # Usage example:
    #  register_element_exporters(:html,
    #                                 image: MyImageExporter,
    #                                 advertisement: MyAdExporter)
    # @param [Symbol] exporter
    # @param [Hash[Symbol => Class]] type_class_mapping
    def register_element_exporters(exporter, type_class_mapping)
      valid_exporters = %i(html amp facebook_instant_article)
      unless valid_exporters.include?(exporter)
        raise ArgumentError, '`exporter` needs to be one of ' \
                             "#{valid_exporters} but is `#{exporter.inspect}`"
      end
      if !type_class_mapping.is_a?(Hash) ||
          type_class_mapping.keys.any? { |key| !key.is_a? Symbol } ||
          type_class_mapping.values.any? { |value| !value.is_a? Class }
        raise ArgumentError, '`type_class_mapping` has to be a Hash with '\
                             'symbolized keys and classes as values but is '\
                             "`#{type_class_mapping.inspect}`"
      end

      @custom_element_exporters[exporter.to_sym] ||= {}
      @custom_element_exporters[exporter.to_sym].merge!(type_class_mapping)
    end

    # Get custom exporter class for a given exporter and element type
    # @param [Symbol] exporter_type
    # @param [Symbol] element_type
    # @return [Class|nil]
    def element_exporter_for(exporter_type, element_type)
      @custom_element_exporters.dig(exporter_type, element_type)
    end
  end
end

