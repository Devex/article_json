module ArticleJSON
  module Export
    module HTML
      class Exporter
        include ArticleJSON::Export::Common::HTML::Exporter

        class << self
          # Return the module namespace this class is nested in
          # @return [Module]
          def namespace
            ArticleJSON::Export::HTML
          end
        end
      end
    end
  end
end
