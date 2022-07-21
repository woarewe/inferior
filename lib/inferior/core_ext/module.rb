# frozen_string_literal: true

require_relative '../core/dsl/interface'

class Module
  def interface!
    raise TypeError, "a class can not declared as an interface" if instance_of?(Class)

    extend Inferior::Core::DSL::Interface
  end
end
