class Sample
  prepend Mixable1, Mixable2
  extend Mixable1, Mixable2
  include Mixable1, Mixable2

  module Mixable1
    # @return [String]
    def greeting
      "Hello"
    end
  end

  module Mixable2
    # @return [String]
    def greeting
      "Hello"
    end
  end
end
