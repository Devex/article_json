module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        module Shared
          module Float
            # Check if the quote is floating (left, right or not at all)
            # @return [Symbol]
            def float
              return unless @float_node.has_attribute?('class')
              node_class = @float_node.attribute('class').value || ''
              return :right if @css_analyzer.right_aligned?(node_class)
              return :left if @css_analyzer.left_aligned?(node_class)
              nil
            end
          end
        end
      end
    end
  end
end
