module Fuzzer
  module Strategies
    class Base
      def initialize(population)
        @population = population
        @coverage = {}
      end

      def add_to_population(string, index)
        result = Coverage.result(stop: false, clear: true)

        unless coverage.has_key?(result)
          population << string
          coverage[result] = index
        end
      end

      def print_coverage_result
        covered_line_count = 0
        total_line_count = 0

        results = coverage.keys

        all_files = results.flat_map(&:keys).uniq

        all_files.each do |file|
          file_results = results.map { |result| result[file] }.compact

          first_result = file_results.first.dup
          total_line_count += first_result.compact.count
          temp_covered_line_count = first_result.compact.count { |number| number.positive? }

          file_results.each do |result|
            result.each_with_index do |number, index|
              if first_result[index] == 0 && number && number.positive?
                temp_covered_line_count += 1
                first_result[index] = number
              end
            end
          end

          covered_line_count += temp_covered_line_count
        end

        coverage_result = (100.0 * covered_line_count / total_line_count).round(2)
        puts "Coverage: #{coverage_result}%"

        puts "Found #{coverage.values.size} unique paths"
        print coverage.each_with_index.map { |(_, step), index| [index, step] }
        print "\n"
      end

      private

      attr_reader :population, :coverage
    end
  end
end
