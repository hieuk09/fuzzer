module Fuzzer
  class Util
    class << self
      def random(min, max)
        if min >= max
          max = min + 1
        end

        min + SecureRandom.random_number(max - min)
      end
    end
  end
end
