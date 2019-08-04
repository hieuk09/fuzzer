require 'coverage'

module Fuzzer
  class Runner
    DEFAULT_PATTERN = //

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
      strategy.fuzz(fuzzer_options) do |string|
        yield string
      end

      covered_line_count = 0
      total_line_count = 0
      result = Coverage.result

      result.each do |file_name, coverage|
        total_line_count += coverage.compact.count
        covered_line_count += coverage.compact.count { |number| number.positive? }
      end

      coverage_result = (100.0 * covered_line_count / total_line_count).round(2)

      puts "Coverage: #{coverage_result}%"
    end

    private

    attr_reader :strategy, :fuzzer_options, :runner_options

    def coverage_pattern
      runner_options[:coverage_pattern] || DEFAULT_PATTERN
    end
  end
end
