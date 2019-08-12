require "fuzzer/version"
require 'fuzzer/strategies/random'
require 'fuzzer/strategies/mutational'
require 'fuzzer/strategies/greybox'
require 'fuzzer/strategies/grammar'
require 'fuzzer/runner'
require 'fuzzer/generator'

module Fuzzer
  class Error < StandardError; end
  # Your code goes here...
end
