module ArticleJSON
  module Export
    module AppleNews
      module Elements
        class Text < Base
          include ArticleJSON::Export::Common::HTML::Elements::Base
          include ArticleJSON::Export::Common::HTML::Elements::Text

          UNSUPPORTED_HTML_TAGS = %w[title meta script noscript style link applet object iframe
            noframes form select option optgroup
          ].freeze

          # A Nokogiri object is returned with`super`, which is is then
          # returned as a either a string or as HTML (when not plain text),
          # both of which are compatible with Apple News format. Takes into
          # account bold, italic and href.
          # @return [String]
          def export
            super.to_s
          end

          # @param [String] text
          def create_text_nodes(text)
            Nokogiri::HTML.fragment(sanitize_text(text).gsub(/\n/, '<br>')).children
          end

          # Removes UNSUPPORTED_TAGS from text
          #
          # @param [String] text
          # @return [String]
          def sanitize_text(text)
            doc = Nokogiri::HTML.fragment(text)
            UNSUPPORTED_HTML_TAGS.each do |tag|
              doc.search(tag).each(&:remove)
            end
            doc.inner_html
          end
        end
      end
    end
  end
end
