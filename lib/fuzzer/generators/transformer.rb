module Fuzzer
  module Generators
    class Transformer
      def initialize(generator, transformer)
        @generator = generator
        @transformer = transformer
      end

      def generate
        transformer.transform(generator.generate)
      end

      private

      attr_reader :generator, :transformer
    end
  end
end
