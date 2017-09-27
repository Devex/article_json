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
    attr_accessor :html_element_exporter

    def initialize
      @oembed_user_agent = nil
      @html_element_exporter = {}
    end

    # Register a new HTML element exporter or overwrite existing ones.
    # @param [Symbol] type
    # @param [Class] klass
    def register_html_element_exporter(type, klass)
      @html_element_exporter[type.to_sym] = klass
    end
  end
end

