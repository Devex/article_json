module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Text < Base
          include ArticleJSON::Export::Common::HTML::Elements::Text
        end
      end
    end
  end
end
