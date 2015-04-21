module Garden
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
end
