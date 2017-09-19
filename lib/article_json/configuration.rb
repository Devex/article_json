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
    end
  end
end

