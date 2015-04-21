require 'garden/version'
require 'garden/aspects/category'
require 'forwardable'

module Garden
  Infinity = 1.0/0

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
	0..10 => :zygote,
        10..Infinity => :embryo
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
	0..90   => :dry,
        90..100 => :well_hydrated
    end

    module Hydration
      extend Forwardable
      def_delegator :moisture, :dereference, :moisture_category
      def_delegator :moisture, :decrement, :dry!
      def_delegator :moisture, :increment, :water!

      def moisture
	@moisture ||= Moisture.new(100)
      end
    end
  end

  class Flower
    include Aspects::Aging
    include Aspects::Hydration
    include Aspects::Scale
    include Aspects::Harvestable

    attr_accessor :location, :color

    def initialize(location=[0,0],color=:red)
      @location = location
      @color = color
    end

    def develop!
      age!
      grow!
      dry!
      ripen!

      self
    end

    def details
      {
	age: self.age.dereference,
	size: self.size.dereference,
	moisture: self.moisture.dereference,
	ripeness: self.ripeness.dereference
      }
    end
  end

  class Plot
    def develop!
      flowers.each(&:develop!) 
      self
    end

    def plant!(xy)
      flower = Flower.new(xy)
      flowers << flower 
      self
    end

    def water!(xy)
      flower = flowers.detect { |f| f.location == xy }
      flower.water!
      self
    end

    def recompute_layout
      flowers.map do |flower|
        layout[flower.location] = flower.details
      end
      self
    end

    def flowers
      @flowers ||= Array.new(5) { Flower.new }
    end   

    def layout
      @layout ||= {}
    end
  end
end
