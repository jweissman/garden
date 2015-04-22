module Garden
  module Aspects
    class Ripeness < Category
      groups \
	0..20 => :unripe,
	20..100 => :ripe,
	100..Infinity => :rotten
    end

    module Harvestable
      extend Forwardable
      def_delegator :ripeness, :dereference, :ripeness_category
      def_delegator :ripeness, :increment, :ripen!

      def ripeness; @ripeness ||= Ripeness.new(0) end

      def harvest!
	age.reset
	size.reset
	moisture.reset
	ripeness.reset

	self
      end
    end

    class Size < Category
      groups \
          0..50          => :small,
	  50..100        => :medium,
	  100..Infinity  => :large 
    end

    module Scale
      extend Forwardable
      def_delegator :size, :dereference, :size_category
      def_delegator :size, :increment, :grow!

      def size; @size ||= Size.new(0) end
    end

    class Age < Category
      groups \
	0..100 => :seed,
        100..200 => :child,
	200..400 => :adult,
	400..Infinity => :dead
    end

    module Aging
      extend Forwardable
      def_delegator :age, :dereference, :age_category
      def_delegator :age, :increment, :age!

      def age
	@age ||= Age.new(0) 
      end
    end

    class Moisture < Category
      groups \
	(-Infinity)..0 => :very_dry,
	0..50   => :dry,
	50..90 => :hydrated,
        90..100 => :well_hydrated
    end

    module Hydration
      extend Forwardable
      def_delegator :moisture, :dereference, :moisture_category
      def_delegator :moisture, :decrement,   :dry!
      def_delegator :moisture, :reset,       :water!

      def moisture
	@moisture ||= Moisture.new(100)
      end
    end
  end
end
