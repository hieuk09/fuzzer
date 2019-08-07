require 'securerandom'
require 'fuzzer/mutator'
require 'fuzzer/strategies/base'

module Fuzzer
  module Strategies
    class Greybox < Base
      MUTATION_RATE = 2

      def initialize(population, population_size: 10, trials: 10)
        super(population)
        @population_size = population_size
        @trials = trials
      end

      def fuzz(char_start: 32, char_range: 96, distance: 35)
        mutator = Mutator.new(char_start: char_start, char_range: char_range, distance: distance)

        trials.times do
          new_population = generate(population.dup, mutator)

          new_population.each do |string|
            yield string
          end
        end
      end

      private

      attr_reader :population, :population_size, :trials, :coverage

      def generate(original_population, mutator)
        population_size.times.map do
          string = original_population.sample
          new_string = string.dup

          MUTATION_RATE.times.each do
            new_string = mutator.mutate(new_string)
          end

          new_string
        end
      end
    end
  end
end
