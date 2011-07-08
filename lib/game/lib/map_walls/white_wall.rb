class BaseWhiteWall
  attr_accessor :first , :second , :direction
  
  def initialize(info)
    x1 = info[:first][:x]
    y1 = info[:first][:y]
    
    x2 = info[:second][:x]
    y2 = info[:second][:y]
    
    @first  = Vector.new x1 , y1
    @second = Vector.new x2 , y2
    
    if x1 != x2
      @direction = :vertical
    else
      @direction = :horizontal
    end
  end
  
  def to_s
    "<#{self.class.name} #{@first} #{@second}>"
  end
  
  def <=>(other)
    @first.distance_to(Vector.new(0 , 0)) <=> other.first.distance_to(Vector.new(0 , 0))
  end
end

class ClientWhiteWall < BaseWhiteWall
  attr_reader :image , :draw_position
  
  def initialize(info)
    super
    @image = Images["white_wall_#{@direction}".to_sym]
  end
end