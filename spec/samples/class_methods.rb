# frozen_string_literal: true

class Sample
  # @return [String]
  def self.greeting
    'Hello'
  end

  # @param name [String]
  # @return [String]
  def self.greet1(name)
    "Hello #{name}"
  end

  # @param first_name [String]
  # @param last_name [String]
  # @return [String]
  def self.greet2(first_name, last_name)
    "Hello #{first_name} #{last_name}"
  end

  # @param greeting [String]
  # @return [String]
  def self.greet3(greeting = 'Hello')
    greeting
  end

  # @param first_name [String]
  # @param last_name [String]
  # @param greeting [String]
  # @return [String]
  def self.greet4(first_name, last_name, greeting = 'Hello')
    "#{greeting} #{first_name} #{last_name}"
  end

  # @param args [String]
  # @return [String]
  def self.greet5(*args)
    args.join(' ')
  end

  # @param name [String]
  # @return [String]
  def self.greet6(name:)
    "Hello #{name}"
  end

  # @param first_name [String]
  # @param last_name [String]
  # @return [String]
  def self.greet7(first_name:, last_name:)
    "Hello #{first_name} #{last_name}"
  end

  # @param greeting [String]
  # @return [String]
  def self.greet8(greeting: 'Hello')
    greeting
  end

  # @param first_name [String]
  # @param last_name [String]
  # @param greeting [String]
  # @return [String]
  def self.greet9(first_name:, last_name:, greeting: 'Hello')
    "#{greeting} #{first_name} #{last_name}"
  end

  # @param args [String]
  # @return [Array<String>]
  def self.greet10(**args)
    args.map { |k, v| "#{v} #{k}" }
  end

  # @param first_name [String]
  # @param last_name [String]
  # @param greeting [String]
  # @yieldparam greeting [String]
  # @yieldreturn [String]
  # @return [String]
  def self.greet11(first_name, last_name, greeting, &)
    yield("#{greeting} #{first_name} #{last_name}")
  end

  # @return [String]
  private_class_method def self.private_greeting
    'Yo'
  end

  class << self
    private

    # @param name [String]
    # @return [String]
    def private_greet(name)
      "Hello #{name}"
    end
  end

  class NestedClass
    # @return [String]
    def self.greeting
      'Hello'
    end

    # @param name [String]
    # @return [String]
    def self.greet(name)
      "Hello #{name}"
    end

    # @return [String]
    private_class_method def self.private_greeting
      'Yo'
    end

    class << self
      private

      # @param name [String]
      # @return [String]
      def private_greet(name)
        "Hello #{name}"
      end
    end
  end

  module NestedModule
    # @return [String]
    def self.greeting
      'Hello'
    end

    # @param name [String]
    # @return [String]
    def self.greet(name)
      "Hello #{name}"
    end

    # @return [String]
    private_class_method def self.private_greeting
      'Yo'
    end

    class << self
      private

      # @param name [String]
      # @return [String]
      def private_greet(name)
        "Hello #{name}"
      end
    end
  end
end
