module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Embed < Base
          include ArticleJSON::Export::Common::HTML::Elements::Embed
        end
      end
    end
  end
end
