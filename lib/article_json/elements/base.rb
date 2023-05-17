module ArticleJSON
  module Elements
    class Base
      attr_reader :type

      class << self
        # Create an element from a hash, based on the :type field
        # @param [Hash] hash
        # @return [ArticleJSON::Elements::Base]
        def parse_hash(hash)
          klass = element_classes[hash[:type].to_sym]
          klass.parse_hash(hash) unless klass.nil?
        end

        # Create a list of elements from an array of hashes
        # @param [Array[Hash]] hash_list
        # @return [Array[ArticleJSON::Elements::Base]]
        def parse_hash_list(hash_list)
          hash_list.map { |hash| Base.parse_hash(hash) }.compact
        end

        private

        def element_classes
          {
            embed: Embed,
            heading: Heading,
            image: Image,
            list: List,
            paragraph: Paragraph,
            quote: Quote,
            text: Text,
            text_box: TextBox,
          }
        end
      end
    end
  end
end
