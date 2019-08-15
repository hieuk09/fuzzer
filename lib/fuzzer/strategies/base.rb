require 'digest'

module Fuzzer
  module Strategies
    class Base
      attr_reader :coverage

      def initialize(population)
        @population = population
        @coverage = {}
      end

      def add_to_population(string, index)
        result = Coverage.result(stop: false, clear: true)
        result = convert_to_string(result)

        unless coverage.has_key?(result)
          population << string
          coverage[result] = index
        end
      end

      private

      attr_reader :population

      def convert_to_string(result)
        string = Marshal.dump(result)
        Digest::MD5.hexdigest(string)
      end
    end
  end
end
