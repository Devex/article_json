module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class EmbeddedElement
          # @param [Nokogiri::XML::Node] node
          # @param [Nokogiri::XML::Node] caption_node
          # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
          def initialize(node:, caption_node:, css_analyzer:)
            @node = node
            @caption_node = caption_node
            @css_analyzer = css_analyzer
          end

          # Extract any potential tags, specified in brackets after the URL
          # @return [Array[Symbol]]
          def tags
            match = /(.*?)[\s\u00A0]+\[(.*)\]/.match(@node.inner_text)
            (match ? match[2] : '').split(' ')
          end

          # Parse the embed's caption node
          # @return [Array[ArticleJSON::Import::GoogleDoc::HTML::TextElement]]
          def caption
            TextElement.extract(
              node: @caption_node,
              css_analyzer: @css_analyzer
            )
          end

          # Hash representation of the embedded element
          # @return [Hash]
          def to_h
            {
              type: :embed,
              embed_type: embed_type,
              embed_id: embed_id,
              tags: tags,
              caption: caption.map(&:to_h),
            }
          end

          class << self
            # Build a embedded element based on the node's content
            # @param [Nokogiri::XML::Node] node
            # @param [Nokogiri::XML::Node] caption_node
            # @param [ArticleJSON::Import::GoogleDoc::HTML::CSSAnalyzer] css_analyzer
            # @return [ArticleJSON::Import::GoogleDoc::HTML::EmbeddedElement]
            def build(node:, caption_node:, css_analyzer:)
              find_class(node.inner_text)
                &.new(
                  node: node,
                  caption_node: caption_node,
                  css_analyzer: css_analyzer
                )
            end

            # Check if a node contains a supported embedded element
            # @param [Nokogiri::XML::Node] node
            # @return [Boolean]
            def matches?(node)
              !find_class(node.inner_text).nil?
            end

            private

            # List of embedded element classes
            # @return [ArticleJSON::Import::GoogleDoc::HTML::EmbeddedElement]
            def element_classes
              [
                EmbeddedVimeoVideoElement,
              ]
            end

            # Find the first matching class for a given (URL) string
            # @param [String] text
            # @return [Class]
            def find_class(text)
              text = text.strip.downcase
              return nil if text.empty?
              element_classes.find { |klass| klass.matches?(text) }
            end
          end
        end
      end
    end
  end
end
