module ArticleJSON
  module Export
    module AMP
      module Elements
        module Shared
          module Float
            # The element's floating class, if necessary
            # @return [String]
            def floating_class
              "float-#{@element.float}" unless @element.float.nil?
            end
          end
        end
      end
    end
  end
end
