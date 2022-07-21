# frozen_string_literal: true

require_relative "../method"

module Inferior
  module Core
    module DSL
      module Interface
        def extends(interface)
          interface.required_methods.each do |method|
            register_method!(method)
          end
        end

        def require_method(name, signature_lambda = -> {})
          method = Method.build!(
            parameters: Method.parse_parameters!(signature_lambda),
            name: name,
          )
          register_method!(method)
        end

        def required_methods
          @required_methods ||= {}
        end

        def verify!(klass)
          required_methods.each { |_name, method| method.verify_class!(klass) }
        end

        private

        def register_method!(method)
          if required_methods.include?(method.name)
            raise ArgumentError, "A method with the name #{method.name} is already defined in the interface"
          end

          required_methods[method.name] = method
        end
      end
    end
  end
end
