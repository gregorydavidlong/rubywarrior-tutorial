class Player

  MAX_HEALTH = 20

  # The point at which the warrior retreats from an attack
  RETREAT_HEALTH = 10

  def play_turn(warrior)
        
    if under_attack
        handle_attack(warrior) 
    else
        rest_then_move(warrior)
    end

    @health = warrior.health
  end

  def initialise(warrior)
    #set-up health variable
    if @health.nil?
        @health = warrior.health
    end

    if @explored_backwards.nil?
        @explored_backwards = false
    end

    if @explored_backwards
        @target_direction = :forward
        @alt_direction = :backward
    else
        @target_direction = :backward
        @alt_direction = :backward
    end

    @front_space = warrior.feel(@target_direction)
    @rear_space = warrior.feel(@alt_direction)

    puts "Forwards is ", @front_space
    puts "Backwards is ", @rear_space

    #are we under attack?
    under_attack = under_attack?(warrior)
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
        @explored_backwards = true
    end

  end
end
