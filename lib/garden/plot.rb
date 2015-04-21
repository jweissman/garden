module Garden
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
      flower_at(xy).water!
      self
    end

    def harvest!(xy)
      flower = flower_at(xy)
      flower.harvest!
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

    def flower_at(xy)
      flowers.detect { |f| f.location == xy }
    end
  end
end
