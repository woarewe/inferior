# frozen_string_literal: true

require_relative '../core/dsl/interface'

class Module
  class << self
    def interface
      extend RuntimeInterfaces::Core::DSL::Interface
    end
  end
end
