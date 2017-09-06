module ArticleJSON
  module Import
    module GoogleDoc
      module HTML
        class CSSParser
          attr_reader :css_parser,
                      :bold_classes,
                      :italic_classes,
                      :centered_classes,
                      :right_aligned_classes

          # Initialize the parser with CSS code
          # @param [String] css
          def initialize(css = '')
            @css_parser = ::CssParser::Parser.new
            css_parser.load_string!(css)
            parse
          end

          # Check if a given class attribute contains at least one class that
          # makes its text bold
          # @param [String] class_str
          # @return [Boolean]
          def is_bold?(class_str)
            (class_str.split(' ') & bold_classes).any?
          end

          # Check if a given class attribute contains at least one class that
          # makes its text italic
          # @param [String] class_str
          # @return [Boolean]
          def is_italic?(class_str)
            (class_str.split(' ') & italic_classes).any?
          end

          # Check if a given class attribute contains at least one class that
          # sets it's alignment to the right
          # @param [String] class_str
          # @return [Boolean]
          def is_right_aligned?(class_str)
            (class_str.split(' ') & right_aligned_classes).any?
          end

          # Check if a given class attribute contains at least one class that
          # centers it
          # @param [String] class_str
          # @return [Boolean]
          def is_centered?(class_str)
            (class_str.split(' ') & centered_classes).any?
          end

          private

          # Parse the CSS code and save CSS selectors for certain styles
          def parse
            # arrays containing class names for certain formatting
            @bold_classes = []
            @italic_classes = []
            @right_aligned_classes = []
            @centered_classes = []

            css_parser.each_rule_set do |rule_set|
              # does this ruleset make text bold?
              if rule_set_is_bold?(rule_set)
                add_classes(rule_set, bold_classes)
              end
              # does this ruleset make text italic?
              if rule_set_is_italic?(rule_set)
                add_classes(rule_set, italic_classes)
              end
              # does this ruleset make text right-aligned?
              if rule_set_is_right_aligned?(rule_set)
                add_classes(rule_set, right_aligned_classes)
              end
              # does this ruleset make text centered?
              if rule_set_is_centered?(rule_set)
                add_classes(rule_set, centered_classes)
              end
            end
          end

          # @param [CssParser::RuleSet] rule_set
          # @return [Boolean]
          def rule_set_is_bold?(rule_set)
            value = clean_value_from_rule_set(rule_set, 'font-weight')
            value =~ /\d/ ? value.to_i >= 600 : %w(bold bolder).include?(value)
          end

          # @param [CssParser::RuleSet] rule_set
          # @return [Boolean]
          def rule_set_is_italic?(rule_set)
            clean_value_from_rule_set(rule_set, 'font-style') == 'italic'
          end

          # @param [CssParser::RuleSet] rule_set
          # @return [Boolean]
          def rule_set_is_right_aligned?(rule_set)
            clean_value_from_rule_set(rule_set, 'text-align') == 'right'
          end

          # @param [CssParser::RuleSet] rule_set
          # @return [Boolean]
          def rule_set_is_centered?(rule_set)
            clean_value_from_rule_set(rule_set, 'text-align') == 'center'
          end

          # @param [CssParser::RuleSet] rule_set
          # @param [String] key
          # @return [String]
          def clean_value_from_rule_set(rule_set, key)
            rule_set
              .get_value(key)
              .to_s
              .tr(';', '')
              .strip
          end

          # Add all class selectors of a rule set to a given array
          # @param [CssParser::RuleSet] rule_set
          # @param [Array] class_array
          def add_classes(rule_set, class_array)
            rule_set.each_selector do |selector|
              selector_name = selector.to_s.strip
              if selector_name[0] == '.'
                selector_name = selector_name[1, selector_name.length]
                unless class_array.include?(selector_name)
                  class_array << selector_name
                end
              end
            end
          end
        end
      end
    end
  end
end
