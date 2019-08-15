require 'securerandom'
require 'fuzzer/mutator'
require 'fuzzer/strategies/base'

module Fuzzer
  module Strategies
    class Mutational < Base
      MUTATION_RATE = 2

      def initialize(population, population_size: 10, trials: 10)
        super(population)
        @population_size = population_size
        @trials = trials
      end

      def fuzz(char_start: 32, char_range: 96, distance: 35, mutation_rate: MUTATION_RATE)
        new_population = population.dup
        mutator = Mutator.new(char_start: char_start, char_range: char_range, distance: distance)

        trials.times do
          new_population = generate(new_population, mutator, mutation_rate)

          new_population.each do |string|
            yield string
          end
        end
      end

      private

      attr_reader :population_size, :trials

      def generate(original_population, mutator, mutation_rate)
        population_size.times.map do
          string = original_population.sample
          new_string = string.dup

          mutation_rate.times.each do
            new_string = mutator.mutate(new_string)
          end

          new_string
        end
      end
    end
  end
end
