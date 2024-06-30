# frozen_string_literal: true

class Sample
  # @return [String]
  @greeting = 'Hello'

  # @return [Array<String>]
  @roles = %w[admin user guest]

  class NestedClass
    # @return [String]
    @greeting = 'Hello'

    # @return [Array<String>]
    @roles = %w[admin user guest]
  end

  module NestedModule
    # @return [String]
    @greeting = 'Hello'

    # @return [Array<String>]
    @roles = %w[admin user guest]
  end
end
