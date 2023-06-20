module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Text < Base
          include ArticleJSON::Export::Common::HTML::Elements::Base
          include ArticleJSON::Export::Common::HTML::Elements::Text

          # A Nokogiri object is returned with`super`, which is is then
          # returned as a either a string or as HTML (when not plain text),
          # both of which are compatible with Apple News format. Takes into
          # account bold, italic and href.
          # @return [String]
          def export
            super.to_s
          end
        end
      end
    end
  end
end
