require "thread"

TranslucentBlack = Color.rgba(0 , 0 , 0 , 100)

class ClientWindow < Window
  include ShallotUI
  
  attr_accessor :entities , :network , :map , :state , :name
  
  def initialize(network , name , fullscreen = false)
    super 1280 , 800 , fullscreen

    @name      = name
    @messages  = MessageQueue.new
    @entities  = Entities.new
    @state     = ClientWaitingToStartState.new(self)
    
    @network = network
    @network.on :message do |message| @messages << message end
  end
  
  def change_state(state_class , *args)
    clear_ui
    @state = state_class.new(*args)
  end
  
  def host?
    @host
  end
  
  def host!
    @host = true
  end
  
  def draw
    if @map
      draw_map
      draw_entities
      draw_tile_highlight
    end
      
    draw_ui
  end
  
  def draw_tile_highlight
    x = mouse_x - (mouse_x % 50)
    y = mouse_y - (mouse_y % 50)
    Images[:tile_highlight].draw x , y , 50
  end
  
  def draw_entities
    @entities.each do |entity|
      entity.image.draw entity.position[:x] * entity.image.width , entity.position[:y] * entity.image.height , 1
    end
  end
  
  def draw_map
    @map.tiles.each do |tile|
      tile.image.draw tile.x * tile.image.width , tile.y * tile.image.height , 1
    end
  end
  
  def update
    @messages.each {|message| @state.handle_message message}
  end
  
  def button_down(id)
    close if id == KbEscape
    @state.button_down id
  end
  
  def start
    @network.start
    show
  end
end
