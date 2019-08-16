require 'fuzzer/util'

module Fuzzer
  class Mutator
    def initialize(char_start: 32, char_range: 96, distance: 35, generator: nil)
      @char_start = char_start
      @char_range = char_range
      @distance = distance
      @generator = generator
    end

    def generate
      generator.generate
    end

    def mutate(string)
      [
        delete_random_character(string),
        add_random_character(string, char_start: char_start, char_range: char_range),
        flipbit_random_character(string),
        change_random_character(string, distance: distance),
        generate
      ].compact.sample
    end

    private

    attr_reader :char_start, :char_range, :distance, :generator

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

      if length.positive?
        flip_position = SecureRandom.random_number(length)
        string.dup.tap do |new_string|
          new_string[flip_position] = flipbit(new_string[flip_position])
        end
      else
        string
      end
    end

    def flipbit(char)
      bin = char.unpack("b*")[0].to_i(2)
      flip = bin ^ 0xff
      [flip.to_s(2)].pack("b*")
    end

    def change_random_character(string, distance:)
      if string.empty?
        string
      else
        difference = SecureRandom.random_number(distance)
        sign = SecureRandom.random_number(2) == 0 ? 1 : -1
        position = SecureRandom.random_number(string.length)

        string.dup.tap do |new_string|
          new_char = [255, [new_string[position].ord + difference * sign, 0].max].min
          new_string[position] = new_char.chr
        end
      end
    end

    def generate
      generator&.generate
    end
  end
end
