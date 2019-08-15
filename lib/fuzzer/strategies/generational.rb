require 'fuzzer/strategies/base'

module Fuzzer
  module Strategies
    class Generational < Base
      def initialize(generator, trials: 10)
        super([])
        @generator = generator
        @trials = trials
      end

      def fuzz(_)
        trials.times.each do
          yield generator.generate
        end
      end

      private

      attr_reader :generator, :trials
    end
  end
end
