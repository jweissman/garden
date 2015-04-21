module Garden
  module Aspects
    class Category
      def initialize(value)
	@value = value
	@initial_value = value
      end

      def self.groups(kvs)
	@strata = kvs
      end

      def self.key_for(value)
	@strata.keys.detect do |range|
	  range.cover?(value)
	end
      end

      def self.category_for(value)
	@strata[key_for(value)]
      end

      def self.values; @strata.values end

      def dereference
        self.class.category_for @value
      end

      def increment
	@value = @value + 1
	self
      end
      
      def decrement
	@value = @value - 1
	self
      end

      def reset
	@value = @initial_value
	self
      end
    end
  end
end

