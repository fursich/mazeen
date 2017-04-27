module ScoutGenerator
  Dirs = [ [0,1], [1,0], [0,-1], [-1,0] ]

  class Scout
    attr_accessor :pos, :last_dir, :cost, :path
    def initialize(pos: [0,0], last_dir: [0,0], path: [], cost: -1)
      @pos = pos
      @last_dir = last_dir
      @path = path
      return @cost = cost
    end

    def reached_to?(pos)
      @pos == pos
    end

    def accessible_dir(maze, min_cost)
      return [] if min_cost[@pos] && @cost > min_cost[@pos]

      dirs = []
      Dirs.each do |dir|
        next if @last_dir == dir.map{|x| -x}
        new_pos = [ @pos[0]+dir[0], @pos[1]+dir[1] ]
        new_cost = @cost + (dir == @last_dir ? 0 : 1)
        next if maze[new_pos].nil?
        next if min_cost[new_pos] && new_cost > min_cost[new_pos]

        dirs << dir
      end
      dirs
    end

    def move_to(dir, min_cost)
      new_pos = [ @pos[0]+dir[0], @pos[1]+dir[1] ]
      new_cost = @cost + (dir == @last_dir ? 0 : 1)
      min_cost[new_pos] = new_cost
      path = @path + [@pos]

      self.class.new(pos: new_pos, last_dir: dir, path: path, cost: new_cost)
    end

  end
end
