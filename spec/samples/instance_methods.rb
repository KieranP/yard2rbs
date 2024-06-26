class Sample
  # @return [String]
  def greeting
    "Hello"
  end

  # @param name [String]
  # @return [String]
  def greet1(name)
    "Hello #{name}"
  end

  # @param first_name [String]
  # @param last_name [String]
  # @return [String]
  def greet2(first_name, last_name)
    "Hello #{first_name} #{last_name}"
  end

  # @param greeting [String]
  # @return [String]
  def greet3(greeting = "Hello")
    greeting
  end

  # @param first_name [String]
  # @param last_name [String]
  # @param greeting [String]
  # @return [String]
  def greet4(first_name, last_name, greeting = "Hello")
    "#{greeting} #{first_name} #{last_name}"
  end

  # @param args [String]
  # @return [String]
  def greet5(*args)
    args.join(' ')
  end

  # @param name [String]
  # @return [String]
  def greet6(name:)
    "Hello #{name}"
  end

  # @param first_name [String]
  # @param last_name [String]
  # @return [String]
  def greet7(first_name:, last_name:)
    "Hello #{first_name} #{last_name}"
  end

  # @param greeting [String]
  # @return [String]
  def greet8(greeting: "Hello")
    greeting
  end

  # @param first_name [String]
  # @param last_name [String]
  # @param greeting [String]
  # @return [String]
  def greet9(first_name:, last_name:, greeting: "Hello")
    "#{greeting} #{first_name} #{last_name}"
  end

  # @param args [String]
  # @return [Array<String>]
  def greet10(**args)
    args.map { |k,v| "#{v} #{k}" }
  end

  # @param first_name [String]
  # @param last_name [String]
  # @param greeting [String]
  # @yieldparam greeting [String]
  # @yieldreturn [String]
  # @return [String]
  def greet11(first_name, last_name, greeting, &block)
    yield(f"#{greeting} #{first_name} #{last_name}")
  end

  # @return [String]
  private def private_greeting
    "Yo"
  end

  private

  # @param name [String]
  # @return [String]
  def private_greet(name)
    "Hello #{name}"
  end

  class NestedClass
    # @return [String]
    def greeting
      "Hello"
    end

    # @param name [String]
    # @return [String]
    def greet(name)
      "Hello #{name}"
    end

    # @return [String]
    private def private_greeting
      "Yo"
    end

    private

    # @param name [String]
    # @return [String]
    def private_greet(name)
      "Hello #{name}"
    end
  end

  module NestedModule
    # @return [String]
    def greeting
      "Hello"
    end

    # @param name [String]
    # @return [String]
    def greet(name)
      "Hello #{name}"
    end

    # @return [String]
    private def private_greeting
      "Yo"
    end

    private

    # @param name [String]
    # @return [String]
    def private_greet(name)
      "Hello #{name}"
    end
  end
end
