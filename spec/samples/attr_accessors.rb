# frozen_string_literal: true

class Sample
  # @return [String]
  attr_accessor :email

  # @return [String]
  attr_accessor :first_name, :last_name

  # @return [Array<String>]
  attr_accessor :roles

  class NestedClass
    # @return [String]
    attr_accessor :email

    # @return [String]
    attr_accessor :first_name, :last_name

    # @return [Array<String>]
    attr_accessor :roles
  end

  module NestedModule
    # @return [String]
    attr_accessor :email

    # @return [String]
    attr_accessor :first_name, :last_name

    # @return [Array<String>]
    attr_accessor :roles
  end
end
