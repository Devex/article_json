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
    attr_accessor :oembed_user_agent, :facebook_token

    def initialize
      @oembed_user_agent = nil
      @facebook_token = nil
      @custom_element_exporters = {}
    end

    # Register new element exporters or overwrite existing ones for a given
    # exporter type.
    # Usage example:
    #  register_element_exporters(:html,
    #                             image: MyImageExporter,
    #                             advertisement: MyAdExporter)
    # @param [Symbol] exporter
    # @param [Hash[Symbol => Class]] type_class_mapping
    def register_element_exporters(exporter, type_class_mapping)
      valid_exporters = %i(html amp facebook_instant_article plain_text)
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

