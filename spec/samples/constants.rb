class Sample
  # @return [String]
  GREETING = "Hello"

  # @return [Array<String>]
  ROLES = %w[admin user guest]

  class NestedClass
    # @return [String]
    GREETING = "Hello"

    # @return [Array<String>]
    ROLES = %w[admin user guest]
  end

  module NestedModule
    # @return [String]
    GREETING = "Hello"

    # @return [Array<String>]
    ROLES = %w[admin user guest]
  end
end
