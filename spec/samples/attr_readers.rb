# frozen_string_literal: true

class Sample
  # @return [String]
  attr_reader :email

  # @return [String]
  attr_reader :first_name, :last_name

  # @return [Array<String>]
  attr_reader :roles

  class NestedClass
    # @return [String]
    attr_reader :email

    # @return [String]
    attr_reader :first_name, :last_name

    # @return [Array<String>]
    attr_reader :roles
  end

  module NestedModule
    # @return [String]
    attr_reader :email

    # @return [String]
    attr_reader :first_name, :last_name

    # @return [Array<String>]
    attr_reader :roles
  end
end
