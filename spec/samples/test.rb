# https://rubydoc.info/gems/yard/file/docs/GettingStarted.md
class Hello
  # @return [Array<Integer>]
  DATA = [1, 2, 3]

  attr_accessor :first_name, :last_name
  attr_reader :dob
  attr_writer :dob

  # @return [Integer]
  @@class_var = 1

  # @return [Integer]
  @instance_var = 2

  # @return [String]
  def self.test1
    'hello'
  end

  # @param txt [String]
  # @param str [String, Integer, nil]
  # @param num [Integer]
  # @param other1 []
  # @param bool [Boolean]
  # @param date [Date]
  # @param other2 []
  # @return [Boolean]
  # @return [String, Integer]
  def self.test2(txt, str = "", num = 1, *other1, bool:, date: Date.now, **other2, &block)
    bool || txt
  end

  # @return [String]
  def test3
    'hello'
  end

  # @param txt [String]
  # @param str [String, nil]
  # @param num [Integer]
  # @param other1 []
  # @param bool [Boolean]
  # @param date [Date]
  # @param other2 []
  # @return [Boolean]
  # @return [String, Integer]
  def test4(txt, str = "", num = 1, *other1, bool:, date: Date.now, **other2, &block)
    bool || txt
  end

  alias_method :test1b, :test1
  alias_method :test2b, :test2
  alias :test3b :test3
  alias test4b test4

  class Nested
    DATA = [1, 2, 3]

    # @return [String]
    def self.test1
      'hello'
    end

    # @param txt [String]
    # @param str [String, nil]
    # @param num [Integer]
    # @param other1 []
    # @param bool [Boolean]
    # @param date [Date]
    # @param other2 []
    # @return [Boolean]
    # @return [String, Integer]
    def self.test2(txt, str = "", num = 1, *other1, bool:, date: Date.now, **other2, &block)
      bool || txt
    end

    # @return [String]
    def test3
      'hello'
    end

    # @param txt [String]
    # @param str [String, nil]
    # @param num [Integer]
    # @param other1 []
    # @param bool [Boolean]
    # @param date [Date]
    # @param other2 []
    # @return [Boolean]
    # @return [String, Integer]
    def test4(txt, str = "", num = 1, *other1, bool:, date: Date.now, **other2, &block)
      bool || txt
    end
  end

  class Inherited < Nested
    extend Mixable1, Mixable2
    prepend Mixable1, Mixable2
    include Mixable1, Mixable2
  end

  module Mixable1
    private

    # @return [String]
    def test3
      'hello'
    end

    public

    # @return [String]
    def test4
      'hello'
    end
  end

  module Mixable2
    # @return [String]
    private def test3
      'hello'
    end

    # @return [String]
    def test4
      'hello'
    end
  end
end
