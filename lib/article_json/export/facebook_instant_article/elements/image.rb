module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Image < Base
          include ArticleJSON::Export::Common::HTML::Elements::Image
        end
      end
    end
  end
end
