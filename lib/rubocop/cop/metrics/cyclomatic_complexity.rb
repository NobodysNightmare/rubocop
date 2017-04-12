# frozen_string_literal: true

module RuboCop
  module Cop
    module Metrics
      # This cop checks that the cyclomatic complexity of methods is not higher
      # than the configured maximum. The cyclomatic complexity is the number of
      # linearly independent paths through a method. The algorithm counts
      # decision points and adds one.
      #
      # An if statement (or unless or ?:) increases the complexity by one. An
      # else branch does not, since it doesn't add a decision point. The &&
      # operator (or keyword and) can be converted to a nested if statement,
      # and ||/or is shorthand for a sequence of ifs, so they also add one.
      # Loops can be said to have an exit condition, so they add one.
      class CyclomaticComplexity < Cop
        class << self
          attr_reader :total_cyclo
          attr_reader :total_methods

          def add_cyclo(cyclo)
            @total_cyclo = (@total_cyclo || 0) + cyclo
          end

          def add_method
            @total_methods = (@total_methods || 0) + 1
          end
        end

        include MethodComplexity

        MSG = 'Cyclomatic complexity for %s is too high. [%d/%d]'.freeze
        COUNTED_NODES = %i[if while until for
                           rescue when and or].freeze

        def on_method_def(node, *args)
          self.class.add_method
          self.class.add_cyclo(complexity(node))

          super
        end

        private

        def complexity_score_for(_node)
          1
        end
      end
    end
  end
end
