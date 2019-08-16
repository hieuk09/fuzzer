require 'coverage'
require 'benchmark'

module Fuzzer
  class Runner
    def initialize(strategy, fuzzer_options = {}, runner_options = {})
      @strategy = strategy
      @fuzzer_options = fuzzer_options
      @runner_options = runner_options
    end

    def before
      Coverage.start

      yield
    end

    def run
      index = 0

      time = Benchmark.measure do
        strategy.fuzz(fuzzer_options) do |string|
          yield string
          strategy.add_to_population(string, index)
          index += 1
        end
      end

      puts "Running #{index} inputs took #{time.total} seconds"

      print_coverage_result
    end

    private

    attr_reader :strategy, :fuzzer_options, :runner_options

    def print_coverage_result
      coverage = strategy.coverage
      puts "Found #{coverage.keys.size} unique paths"
    end
  end
end
