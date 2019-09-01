require "fuzzer/version"
require 'fuzzer/generators/random'
require 'fuzzer/generators/grammar'
require 'fuzzer/generators/transformer'
require 'fuzzer/strategies/mutational'
require 'fuzzer/strategies/greybox'
require 'fuzzer/strategies/generational'
require 'fuzzer/strategies/combination'
require 'fuzzer/runner'

module Fuzzer
  class Error < StandardError; end
  # Your code goes here...
end
