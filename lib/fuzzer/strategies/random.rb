require 'securerandom'
require 'fuzzer/strategies/base'

module Fuzzer
  module Strategies
    class Random < Base
      def initialize(count)
        super([])
        @count = count
      end

      def fuzz(max_length: 100, min_length: 0, char_start: 32, char_range: 96)
        count.times.each do
          length = min_length + SecureRandom.random_number(max_length - min_length)

          string = length.times.map do
            (char_start + SecureRandom.random_number(char_range)).chr
          end.join

          yield string
        end
      end

      private

      attr_reader :count, :population, :coverage
    end
  end
end
