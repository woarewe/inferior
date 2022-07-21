# frozen_string_literal: true

require_relative '../error'

module RuntimeInterfaces
  module Core
    class Parameter
      private_class_method :new

      REQUIRED = :required
      OPTIONAL = :optional
      SPLAT = :splat
      KEYWORD_REQUIRED = :keyword_required
      KEYWORD_OPTIONAL = :keyword_optional
      KEYWORD_SPLAT = :keyword_splat
      BLOCK = :block

      TYPES = Set[
        REQUIRED,
        OPTIONAL,
        SPLAT,
        KEYWORD_REQUIRED,
        KEYWORD_OPTIONAL,
        KEYWORD_SPLAT,
        BLOCK,
      ].freeze

      MAPPING = {
        req: REQUIRED,
        opt: OPTIONAL,
        rest: SPLAT,
        keyreq: KEYWORD_REQUIRED,
        key: KEYWORD_OPTIONAL,
        keyrest: KEYWORD_SPLAT,
        block: BLOCK,
      }.freeze

      Error = Class.new(Error)

      class UnsupportedTypeError < Error
        attr_reader :provided_type

        def initialize(provided_type)
          @provided_type = provided_type

          super <<~MESSAGE.gsub("\n", " ")
            Unsupported parameter type #{provided_type.inspect}.
            Available values are #{TYPES.map(&:inspect).join(", ")}")
          MESSAGE
        end
      end

      InvalidNameError = Class.new(Error)

      class << self
        def build!(name:, type:)
          validate_type!(type)
          validate_name!(name, type)
          new(name: name, type: type)
        end

        def parse!(ruby_internal_type, ruby_internal_name)
          type = MAPPING.fetch(ruby_internal_type)
          build!(type: type, name: ruby_internal_name)
        end

        private

        def validate_name!(name, type)

        end

        def validate_type!(type)
          return if TYPES.include?(type)

          raise UnsupportedTypeError, type
        end
      end

      def initialize(name:, type:)
        @name = name
        @type = type
      end

      def definition
        case type
        when REQUIRED
          name
        when OPTIONAL
          "#{name} = DEFAULT_VALUE"
        when SPLAT
          ["*", name].compact.join
        when KEYWORD_REQUIRED
          "#{name}:"
        when KEYWORD_OPTIONAL
          "#{name}: DEFAULT_VALUE"
        when KEYWORD_SPLAT
          ["**", name].compact.join
        when BLOCK
          ["&", name == "&" ? nil : name].compact
        end
      end

      private

      attr_reader :name, :type
    end
  end
end
