module ArticleJSON
  module Export
    module FacebookInstantArticle
      module Elements
        class Paragraph < Base
          include ArticleJSON::Export::Common::HTML::Elements::Paragraph
        end
      end
    end
  end
end
