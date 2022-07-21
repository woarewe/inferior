# frozen_string_literal: true

require_relative '../error'
require_relative 'parameter'

module RuntimeInterfaces
  module Core
    class Method
      private_class_method :new

      Error = Class.new(Error)

      InvalidNameError = Class.new(Error)

      class << self
        def build!(name:, parameters:)
          validate_name!(name)
          validate_parameters!(parameters)
          new(name: name, parameters: parameters)
        end

        def parse_parameters!(method)
          parameters = parse_parameters!(method)
          build!(parameters: parameters, name: method.name)
        end

        def parse!(method)
          method.parameters.map do |ruby_internal_type, ruby_internal_name|
            Parameter.parse!(ruby_internal_type, ruby_internal_name)
          end
        end

        private

        def validate_name!(name)
          # TODO: Add regular expression to verify method names
        end

        def validate_parameters!(parameters)
          # TODO: Add regular expression to verify parameter classes
        end
      end

      def initialize(name:, parameters:)
        @name = name
        @parameters = parameters
      end

      def definition
        parameters_definition = parameters.any? ? "(#{parameters.map(&:definition).join(", ")})" : nil
        <<~RUBY
          def #{name}#{parameters_definition}
          end
        RUBY
      end

      private

      attr_reader :name, :parameters
    end
  end
end
