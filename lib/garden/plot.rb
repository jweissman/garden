module Garden
  class Plot
    attr_reader :flowers

    def initialize(xys=[[1,1],[1,2]]) #Array.new(2) { Flower.new })
      @flowers = xys.map { |xy| Flower.new(xy) } 
    end

    def develop!
      @flowers.reject! do |flower| 
        flower.age_category == :dead
      end

      @flowers.each(&:develop!) 

      self
    end

    def plant!(xy)
      raise "Cannot plant over existing flowers!" if flower_at(xy)
      flower = Flower.new(xy)
      @flowers << flower 
      self
    end

    def water!(xy)
      flower_at(xy).water! if flower_at(xy)
      self
    end

    def harvest!(xy)
      flower = flower_at(xy)
      flower.harvest! if flower
      self
    end

    def recompute_layout
      @flowers.map do |flower|
        layout[flower.location] = flower.details
      end
      self
    end

    #def flowers
    #  @flowers ||= [] 
    #end   

    def layout
      @layout ||= {}
    end

    def flower_at(xy)
      @flowers.detect { |f| f.location == xy }
    end
  end
end
