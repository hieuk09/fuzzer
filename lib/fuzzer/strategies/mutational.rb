require 'securerandom'
require 'fuzzer/util'

module Fuzzer
  module Strategies
    class Mutational
      def initialize(population)
        @population = population.dup
      end

      def fuzz(char_start: 32, char_range: 96, distance: 35)
        @population = generate(population, char_start: char_start, char_range: char_range, distance: distance)
        @population.each do |string|
          yield string
        end
      end

      private

      attr_reader :population

      def generate(original_population, char_start:, char_range:, distance:)
        100.times.map do
          string = original_population.sample
          new_string = string.dup

          5.times.each do
            new_string = mutate(new_string, char_start: char_start, char_range: char_range, distance: distance)
          end

          new_string
        end
      end

      def mutate(string, char_start:, char_range:, distance:)
        [
          delete_random_character(string),
          add_random_character(string, char_start: char_start, char_range: char_range),
          flipbit_random_character(string),
          change_random_character(string, distance: distance)
        ].sample
      end

      def delete_random_character(string)
        length = string.length
        delete_position = SecureRandom.random_number(length)
        [string[0..delete_position-1], string[(delete_position + 1)..(length - 1)]].join
      end

      def add_random_character(string, char_start:, char_range:)
        length = string.length
        insert_position = SecureRandom.random_number(length)
        char = Util.random(char_start, char_start + char_range).chr
        [string[0..insert_position-1], char, string[(insert_position + 1)..(length - 1)]].join
      end

      def flipbit_random_character(string)
        length = string.length
        flip_position = SecureRandom.random_number(length)
        string.dup.tap do |new_string|
          new_string[flip_position] = flipbit(new_string[flip_position])
        end
      end

      def flipbit(char)
        bin = char.unpack("b*")[0].to_i(2)
        flip = bin ^ 0xff
        [flip.to_s(2)].pack("b*")
      end

      def change_random_character(string, distance:)
        difference = SecureRandom.random_number(distance)
        sign = SecureRandom.random_number(2) == 0 ? 1 : -1
        position = SecureRandom.random_number(string.length)

        string.dup.tap do |new_string|
          new_char = [new_string[position].ord + difference * sign, 0].max
          new_string[position] = new_char.chr
        end
      end
    end
  end
end
