# frozen_string_literal: true

require 'pp'

module Structure
  module Type
    class Error < ::StandardError; end
    class SizeError < Error; end
    class MatchError < Error; end

    class Single
      attr_reader :classes
      def initialize(classes)
        @classes = classes
      end

      def class?
        @classes.all? { |c| c.is_a?(Class) || c.is_a?(Module) }
      end

      def matches?(json)
        result = classes.any? do |s|
          yield s, json
        rescue Structure::Type::Error
          false
        end
        raise MatchError, "#{json}\n is not one of #{inspect}" unless result

        true
      end

      def inspect
        "one_of(#{@classes})"
      end
    end

    class Array < Single
      def initialize(classes)
        super(classes)
        @max = 999_999
        @min = 0
      end

      def between(min, max)
        @min = min
        @max = max
        self
      end

      def at_least(number)
        between(number, Float::INFINITY)
      end

      def with(number)
        @number = number
        self
      end

      def elements
        @min = @number
        @max = @number
        self
      end

      def items
        elements
      end

      def elements_at_most
        raise 'Wrong use of at_most' unless @number

        @max = @number
        @number = nil
        self
      end

      def elements_at_least
        raise 'Wrong use of at_least' unless @number

        @min = @number
        @number = nil
        self
      end

      def matches?(json)
        raise SizeError, "Size Error: #{inspect} size (#{json.size}) is not between #{@min} and #{@max}." unless json.size.between?(@min, @max)

        json.all? { |j| classes.any? { |s| yield s, j } }
      end

      def inspect
        if class?
          "a_list_of(#{@classes.inspect})"
        else
          "a_list_of(\n#{@classes.pretty_inspect})"
        end
      end
    end

    module Methods
      def a_list_of(*class_list)
        Structure::Type::Array.new(class_list)
      end

      def one_of(*class_list)
        Structure::Type::Single.new(class_list)
      end
    end
  end
end
