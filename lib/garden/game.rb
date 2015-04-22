require 'gosu'
require 'pry'

include Garden

module ZOrder
  Background, Flowers, Player, UI = *0..3
end

class GameWindow < Gosu::Window
  include ZOrder

  def initialize
    super 640, 480, false
    self.caption = "Eden"

    @theme   = Gosu::Sample.new(self, "assets/garden.m4a") 
    @images  = Gosu::Image.load_tiles(self, "assets/bg.png", 16, 16, false)
    @tools   = Gosu::Image.load_tiles(self, "assets/tools.png", 16, 16, false)

    @font    = Gosu::Font.new(self, Gosu::default_font_name, 20)

    @playing_theme = false

    @grid_width, @grid_height = self.width/16, self.height/16

    xys = []
    50.times do 
      xys << [(rand * @grid_width).to_i, (rand * @grid_height).to_i]
    end

    @plot = Plot.new(xys)
    @plot.recompute_layout

    @current_tool = :seed

    @t = 0

    puts "--- starting game!"
  end

  def update
    @t = @t + 1
    play_theme unless @playing_theme

    if @t % 5 == 0
      @plot.develop! 
      @plot.recompute_layout
    end

    if button_down?(Gosu::MsLeft)
      if @current_tool == :seed
	@plot.plant!(mouse_coords) unless @plot.flower_at(mouse_coords)
      elsif @current_tool == :water
	@plot.water!(mouse_coords)
      elsif @current_tool == :sickle
	@plot.harvest!(mouse_coords)
      end

      @plot.recompute_layout
    end

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      alternate_tool!
    end
  end

  def draw
    # background
    @grid_width.times do |x|
      @grid_height.times do |y|
	@images[0].draw(x*16,y*16, Background)
      end
    end

    # flowers
    @plot.layout.each do |xy, flower|
      frame = age_to_image(flower[:age])

      # skip dead ones, but should be culled already though?
      next if frame.nil? 
      @images[frame].draw(xy[0]*16, xy[1]*16, Flowers)
    end

    # mouse
    @tools[tool_to_image(@current_tool)].draw(mouse_x, mouse_y, UI)

    @font.draw("Current tool: #@current_tool", 50, 50, UI)
  end

  protected
  def alternate_tool!
    if @current_tool == :water
      @current_tool = :seed
    elsif @current_tool == :seed
      @current_tool = :sickle
    elsif @current_tool == :sickle
      @current_tool = :water
    end
  end

  def mouse_coords
    [(mouse_x/16).to_i, (mouse_y/16).to_i]
  end
  
  def play_theme
    puts "--- playing theme"
    @theme.play
    @playing_theme = true
  end

  def tool_to_image(tool)
    image = if tool == :seed
	      0
	    elsif tool == :water
	      1
	    elsif tool == :sickle
	      2
	    end
    image
  end

  def age_to_image(age_category)
    image = if age_category == :seed
      1
    elsif age_category == :child
      2
    elsif age_category == :adult
      3
    end
    image
  end
end
