module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Quote < Base
          include ArticleJSON::Export::Common::HTML::Elements::Quote
        end
      end
    end
  end
end
