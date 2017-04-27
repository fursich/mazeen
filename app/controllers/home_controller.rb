class HomeController < ApplicationController
  include MinCost

  def index


    height0, width0 = 5,10

    @height = params[:height].to_i || height0
    @width = params[:width].to_i || width0

    @start = [0,0]
    @goal = [@height-1, @width-1]

    base_maze = %w(
      .##.......
      ..#.###.#.
      .##...#.#.
      .....##.#.
      #.#..#..#.
      )

    @maze = to_maze_hash(base_maze)
    @path = path_with_min_cost(@start, @goal, @maze)
    @maze_size = 0
  end

end
