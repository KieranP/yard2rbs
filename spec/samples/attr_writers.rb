# frozen_string_literal: true

class Sample
  # @return [String]
  attr_writer :email

  # @return [String]
  attr_writer :first_name, :last_name

  # @return [Array<String>]
  attr_writer :roles

  class NestedClass
    # @return [String]
    attr_writer :email

    # @return [String]
    attr_writer :first_name, :last_name

    # @return [Array<String>]
    attr_writer :roles
  end

  module NestedModule
    # @return [String]
    attr_writer :email

    # @return [String]
    attr_writer :first_name, :last_name

    # @return [Array<String>]
    attr_writer :roles
  end
end
