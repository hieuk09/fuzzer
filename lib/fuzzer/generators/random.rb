module Fuzzer
  module Generators
    class Random
      def initialize(max_length: 100, min_length: 0, char_start: 32, char_range: 96)
        @max_length = max_length
        @min_length = min_length
        @char_range = char_range
        @char_start = char_start
      end

      def generate
        length = min_length + SecureRandom.random_number(max_length - min_length)

        length.times.map do
          (char_start + SecureRandom.random_number(char_range)).chr
        end.join
      end

      private

      attr_reader :max_length, :min_length, :char_start, :char_range
    end
  end
end
