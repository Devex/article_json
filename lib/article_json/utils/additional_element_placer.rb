module ArticleJSON
  module Utils
    # This class allows the user to place additional elements within an article.
    # It distributes elements over the whole article and ensures that an
    # additional element is only ever placed between two paragraph elements or
    # after a paragraph and before the next headline. If there are not enough
    # spaces, the remaining additional elements will be appended to the existing
    # article elements.
    class AdditionalElementPlacer
      # @param [Array[ArticleJSON::Article::Elements::Base]] elements
      # @param [Array[Object]] additional_elements
      def initialize(elements, additional_elements)
        @elements = elements&.dup
        @additional_elements = additional_elements
      end

      # Distribute additional elements evenly throughout the article elements
      #
      # Outline of the algorithm:
      # 1. It calculates every how many characters (only considering paragraphs)
      #    an additional element should be inserted, given the number of
      #    additional elements provided
      # 2. It then iterates over the existing elements within the article,
      #    inserting them into the resulting, merged article
      # 3. As soon as it has passed the right amount characters, it checks if
      #    the current position is eligible for inserting an additional element
      #    (the previous element needs to be a paragraph and the following needs
      #    to be either a paragraph or a headline)
      #     a) If so, it inserts the additional element and recalculates in how
      #        many characters the next element should be inserted, based on the
      #        remaining number of characters and remaining additional elements
      #     b) If not, it keeps iterating over the article until it finds an
      #        eligible position and only then inserts the additional element
      #        and recalculates the number of characters until the next
      #        insertion
      # 4. If there are still additional elements remaining which couldn't be
      #    inserted (due to not finding enough eligible positions), they are
      #    appended to the end of the article
      #
      # @return [Array[ArticleJSON::Elements::Base|Object]]
      def merge_elements
        return @additional_elements if @elements.nil? || @elements.empty?
        remaining_elements = @additional_elements.dup
        next_in = insert_next_element_in(0, remaining_elements)
        characters_passed = 0
        @elements
          .each_cons(2)
          .each_with_object([]) do |(element, next_element), result|
            result << element
            next if remaining_elements.empty?
            if element.respond_to?(:length)
              characters_passed += element.length
              next_in -= element.length
            end
            if insert_here?(next_in, element, next_element)
              result << remaining_elements.shift
              next_in = insert_next_element_in(characters_passed,
                                               remaining_elements)
            end
          end
          .push(@elements.last,      # add last element
                *remaining_elements) # followed by remaining ads
      end

      private

      # Calculate in how many characters the next additional element should be
      # inserted
      # @param [Integer] characters_passed
      # @param [Array] left_elements
      # @return [Integer]
      def insert_next_element_in(characters_passed, left_elements)
        (total_length - characters_passed) / (left_elements.size + 1)
      end

      # Return the total length of the given elements
      # @return [Integer]
      def total_length
        @total_length ||= @elements.reduce(0) do |sum, element|
          sum + (element.respond_to?(:length) ? element.length : 0)
        end
      end

      # Check if the given position is eligible for inserting an additional
      # element
      # @param [Integer] next_in
      # @param [ArticleJSON::Elements::Base] element
      # @param [ArticleJSON::Elements::Base] next_element
      # @return [Boolean]
      def insert_here?(next_in, element, next_element)
        next_in <= 0 &&
          element.type == :paragraph &&
          %i(paragraph heading).include?(next_element.type)
      end
    end
  end
end
