require 'coverage'

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

      strategy.fuzz(fuzzer_options) do |string|
        yield string
        strategy.add_to_population(string, index)
        index += 1
      end

      strategy.print_coverage_result
    end

    private

    attr_reader :strategy, :fuzzer_options, :runner_options
  end
end
