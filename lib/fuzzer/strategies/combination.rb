module Fuzzer
  module Strategies
    class Combination < Base
      def initialize(generator, mutator, trials: 10, population_size: 10)
        super([])
        @trials = trials
        @generator = generator
        @mutator = mutator
        @population_size = population_size
      end

      def fuzz(mutation_rate: 2)
        seed_run = (trials * 0.1).to_i

        seed_run.times do
          yield generator.generate
        end

        (trials - seed_run).times do
          new_population = generate(population.dup, mutation_rate)

          new_population.each do |string|
            yield string
          end
        end
      end

      private

      attr_reader :mutator, :generator, :trials, :population_size

      def generate(original_population, mutation_rate)
        population_size.times.map do
          string = original_population.sample

          if string.nil?
            mutator.generate
          else
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
end
