# frozen_string_literal: true

require_relative '../error'
require_relative 'parameter'

module RuntimeInterfaces
  module Core
    class Method
      private_class_method :new

      Error = Class.new(Error)

      InvalidNameError = Class.new(Error)
      VerificationError = Class.new(Error)

      class << self
        def build!(name:, parameters:)
          validate_name!(name)
          validate_parameters!(parameters)
          new(name: name, parameters: parameters)
        end

        def parse!(method)
          parameters = parse_parameters!(method)
          build!(parameters: parameters, name: method.name)
        end

        def parse_parameters!(method)
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

      attr_reader :name, :parameters

      def initialize(name:, parameters:)
        @name = name
        @parameters = parameters
      end

      def eql?(other)
        return false unless name.eql?(other.name)
        return false unless parameters.size.eql?(other.parameters.size)

        parameters.each_with_index.all? do |parameter, index|
          parameter.eql?(other.parameters[index])
        end
      end

      def verify_class!(klass)
        unless klass.method_defined?(name)
          raise VerificationError, <<~ERROR.strip
            #{klass.name} should implement a method with the following signature:
              
            #{definition}
          ERROR
        end

        actual = self.class.parse!(klass.instance_method(name))
        return if eql?(actual)

        raise VerificationError, <<~ERROR
          #{klass.name} should implement a method with the following signature:
              
          #{definition}

          but the actual signature is the following:

          #{actual.definition}
        ERROR
      end

      def definition
        parameters_definition = parameters.any? ? "(#{parameters.map(&:definition).join(", ")})" : nil
        <<~RUBY.strip
          def #{name}#{parameters_definition}
          end
        RUBY
      end
    end
  end
end
