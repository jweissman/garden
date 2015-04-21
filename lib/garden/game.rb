require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Eden"

    @theme   = Gosu::Sample.new(self, "assets/garden.m4a") 
    @flowers = Gosu::Image.load_tiles(self, "assets/bg.png", 16, 16, false)

    @playing_theme = false

    puts "--- starting game!"
  end

  def update
    play_theme unless @playing_theme
  end

  def draw
    frame = Gosu::milliseconds / 100 % 4 # @flowers.size
    @flowers[frame].draw(50,50,0)
  end

  def play_theme
    puts "--- playing theme"
    @theme.play
    @playing_theme = true
  end
end
