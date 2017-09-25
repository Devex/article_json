module ArticleJSON
  class Article
    attr_reader :elements

    # @param [Arra[ArticleJSON::Elements::Base]] elements
    def initialize(elements)
      @elements = elements
    end

    # Hash representation of the article
    # @return [Hash]
    def to_h
      {
        article_json_version: VERSION,
        content: @elements.map(&:to_h),
      }
    end

    # JSON representation of the article
    # @return [String]
    def to_json
      to_h.to_json
    end

    # HTML export of the article
    # @return [String]
    def to_html
      ArticleJSON::Export::HTML::Exporter.new(@elements).html
    end

    class << self
      # Build a new article from hash (like the one generated by #to_h)
      # @return [ArticleJSON::Article]
      def from_hash(hash)
        hash = { content: hash } if hash.is_a?(Array)
        new(ArticleJSON::Elements::Base.parse_hash_list(hash[:content]))
      end

      # Build a new article from JSON (like the one generated by #to_json)
      # @return [ArticleJSON::Article]
      def from_json(json)
        from_hash(JSON.parse(json, symbolize_names: true))
      end

      # Build a new article from a Google Doc HTML export
      # @return [ArticleJSON::Article]
      def from_google_doc_html(html)
        parser = ArticleJSON::Import::GoogleDoc::HTML::Parser.new(html)
        new(parser.parsed_content)
      end
    end
  end
end