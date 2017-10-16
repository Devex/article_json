module ArticleJSON
  module Utils
    # This class allows the user to place additional elements within an article.
    # It distributes elements over the whole article and ensures that an
    # additional element is only ever placed between two paragraph elements. If
    # there are not enough spaces, the remaining additional elements will be
    # appended to the existing article elements.
    class AdditionalElementPlacer
      # @param [ArticleJSON::Article] article
      # @param [Array[Object]] additional_elements
      def initialize(article, additional_elements)
        @elements = article.elements.dup
        @additional_elements = additional_elements
      end

      # Distribute additional elements evenly throughout the article elements
      # @return [Array[ArticleJSON::Elements::Base|Object]]
      def merge_elements
        indexes = indexes_for_additional_elements

        if indexes.count < @additional_elements.count
          @elements.push(*@additional_elements[indexes.count..-1])
        end

        indexes
          .reverse
          .zip(@additional_elements[0...indexes.count].reverse)
          .each { |index, element| @elements.insert(index, element) }

        @elements
      end

      private

      # Find indexes within article elements where there is a paragraph on the
      # current and on the next node
      # @return [Array[Integer]]
      def indexes_between_paragraphs
        @elements
          .each_cons(2) # iterate over elements in consecutive sets of 2
          .with_index
          .each_with_object([]) do |((current, following), index), possibilities|
          if current.type == :paragraph && following.type == :paragraph
            possibilities << index + 1
          end
        end
      end

      # Return evenly spread indexes of positions to insert a given number of
      # additional elements
      # @return [Array[Integer]]
      def indexes_for_additional_elements
        indexes = indexes_between_paragraphs
        insert_every = indexes.count / @additional_elements.count

        # in case there are more elements to add than available positions:
        insert_every = 1 if insert_every == 0

        indexes
          .reject
          .with_index { |_, index| (index + 1) % insert_every != 0 }
          .take(@additional_elements.count)
      end
    end
  end
end
