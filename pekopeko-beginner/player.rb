class Player

  MAX_HEALTH = 20

  # The point at which the warrior retreats from an attack
  RETREAT_HEALTH = 10

  def play_turn(warrior)
    initialise(warrior)
   
    @forward_look = warrior.look(:forward)
    @left_look = warrior.look(:left)
    @right_look = warrior.look(:right)
    @backward_look = warrior.look(:backward)

    @directions = [:forward, :left, :right, :backward]
    @surrounds = [@forward_look, @left_look, @right_look, @backward_look]

    puts "Forwards: " + @forward_look.inspect
    puts "Left: " + @left_look.inspect
    puts "Right: " + @right_look.inspect
    puts "Backwards: " + @backward_look.inspect

    make_a_move(warrior)

    @health = warrior.health
  end

  def initialise(warrior)
    #set-up health variable
    if @health.nil?
        @health = warrior.health
    end

    #are we under attack?
    @under_attack = under_attack?(warrior)
  end

  def find_biggest_threat(warrior)
     direction = 0
     #find archers
     for dir_array in @surrounds do
         for x in dir_array do
             if x.inspect == "Archer" then
                    return @directions[direction]
             end
         end
         direction += 1
     end
     direction = 0
     for dir_array in @surrounds do
         for x in dir_array do
             if x.inspect == "Captive" then
                    return @directions[direction]
             end
         end
         direction += 1
     end

     #find captives

     @directions[0]
  end

  def make_a_move(warrior)
    # Locate threats
    direction = find_biggest_threat(warrior)
    if (direction != :forward)
        warrior.pivot!(direction)
    elsif (should_attack?(warrior, @forward_look))
        warrior.shoot!
    elsif (@forward_look[0].empty?)
        warrior.walk!
    elsif (@forward_look[0].captive?)
        warrior.rescue!
    elsif (@forward_look[0].wall?)
        warrior.pivot!(:backward)
    end
  end

  def should_attack?(warrior, look)
    should_attack = false
    look.reverse.each{ |space|
      if (space.enemy?)
        should_attack = true
      elsif (space.captive?)
        should_attack = false
      end
    }
    puts "final should attack: " + should_attack.to_s
    should_attack
  end

  def under_attack?(warrior)
    (warrior.health < @health)
  end

  def handle_attack(warrior)
    if (warrior.health < RETREAT_HEALTH)
        warrior.walk!(@alt_direction)
    elsif @front_space.empty?
        warrior.walk!(@target_direction)
    else
        warrior.attack!(@target_direction)
    end
  end

  def rest_then_move(warrior)
    if (warrior.health != MAX_HEALTH)
        warrior.rest!
    else
        explore(warrior)
    end
  end

  def explore(warrior)

    if (@front_space.empty?)
        warrior.walk!(@target_direction)
    else
        warrior.rescue!(@target_direction)
    end

  end
end
