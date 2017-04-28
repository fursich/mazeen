
module MinCost
  include ScoutGenerator

  def to_maze_hash(base_maze)
    maze = {}
    base_maze.each.with_index do |line, h|
      tmp = line.split('').each.with_index do |c,w|
        maze[[h,w]] =  (c == '#' ? nil : 1)
      end
    end
    maze
  end

  def path_with_min_cost(start, goal, maze, algorithm: :minimum_turns)
    return 0 if start == goal

    if algorithm == :minimum_turns
      cost_incremental = -> (dir, last_dir) {dir == last_dir ? 0 : 1}
    elsif algorithm == :minimum_distance
      cost_incremental = -> (dir, last_dir) {return 1}
    else
      return nil
    end

    loop_count = maze.count
    min_cost = {}
    scouts = []
    scouts << Scout.new(pos: start, &cost_incremental)
    min_path = nil

    loop_count.times do
      new_scouts = []
      scouts.each do |scout|
        if scout.reached_to?(goal)
          min_path = scout.path + [scout.pos]
          next
        end
        dirs = scout.accessible_dir(maze, min_cost)
        dirs.each do |dir|
          new_scouts << scout.move_to(dir, min_cost, &cost_incremental)
        end
      end

      break if new_scouts.empty?
      scouts = new_scouts
    end
    min_path
  end

end
