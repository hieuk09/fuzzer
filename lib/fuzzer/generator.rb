module Fuzzer
  class Generator
    NON_TERMINAL_REGEX = /(<[^<> ]*>)/
    START_ELEMENT = '<start>'.freeze

    def initialize(grammar)
      @grammar = grammar
    end

    def generate
      render(grammar[START_ELEMENT].sample)
    end

    private

    attr_reader :grammar

    def render(string)
      string = string.dup

      elements = string.scan(NON_TERMINAL_REGEX).flatten.uniq
      elements.each do |element|
        string.gsub!(element, render(grammar[element].sample))
      end

      string
    end
  end
end
