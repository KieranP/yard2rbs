# frozen_string_literal: true

class Sample
  # @return [String]
  GREETING = 'Hello'

  # @return [Array<String>]
  ROLES = %w[admin user guest].freeze

  class NestedClass
    # @return [String]
    GREETING = 'Hello'

    # @return [Array<String>]
    ROLES = %w[admin user guest].freeze
  end

  module NestedModule
    # @return [String]
    GREETING = 'Hello'

    # @return [Array<String>]
    ROLES = %w[admin user guest].freeze
  end
end
