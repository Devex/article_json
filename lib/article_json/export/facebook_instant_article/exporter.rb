module ArticleJSON
  module Export
    module FacebookInstantArticle
      class Exporter
        include ArticleJSON::Export::Common::HTML::Exporter

        class << self
          # Return the module namespace this class is nested in
          # @return [Module]
          def namespace
            ArticleJSON::Export::FacebookInstantArticle
          end
        end
      end
    end
  end
end
