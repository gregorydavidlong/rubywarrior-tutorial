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

    puts "Forwards: " + @forward_look.inspect
    puts "Left: " + @left_look.inspect
    puts "Right: " + @right_look.inspect
    puts "Backwards: " + @backward_look.inspect

    make_a_move(warrior)

    #if @change_direction.nil?
    #    @change_direction = false
    #    warrior.pivot!(:backward)
    #elsif @change_direction == true
    #    warrior.pivot!(:forward)
    #    change_direction = false
    #elsif @under_attack
    #    handle_attack(warrior) 
    #else
    #    rest_then_move(warrior)
    #end

    @health = warrior.health
  end

  def initialise(warrior)
    #set-up health variable
    if @health.nil?
        @health = warrior.health
    end

    @target_direction = :forward
    @alt_direction = :backward

    @front_space = warrior.feel(@target_direction)
    @rear_space = warrior.feel(@alt_direction)

    #puts "Forwards is ", @front_space
    #puts "Backwards is ", @rear_space

    #are we under attack?
    @under_attack = under_attack?(warrior)
  end

  def make_a_move(warrior)
    if (should_attack?(warrior, @forward_look))
        warrior.shoot!
    elsif (@forward_look[0].empty?)
        warrior.walk!
    elsif (@forward_look[0].captive?)
        warrior.rescue!
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
        #@change_direction = true
    end

  end
end
