module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Heading < Base
          include ArticleJSON::Export::Common::HTML::Elements::Heading
        end
      end
    end
  end
end
