class MazeController < ApplicationController
  include MinCost

  def index


    height0, width0 = 10,10

    @height = (params[:height] || height0).to_i
    @width = (params[:width] || width0).to_i

    @start = [0,0]
    @goal = [@height-1, @width-1]

    base_maze = %w(
      .##.......
      ..#.###.#.
      .##...#.#.
      ..#..##.#.
      #.#..#..#.
      #.#..#..#.
      #.#..#..#.
      #.#..#..#.
      #.#..#..#.
      #....#..#.
      )

    @maze = to_maze_hash(base_maze)
    @path = path_with_min_cost(@start, @goal, @maze)
  end

  def seek

    height0, width0 = 10,10
    @height = (params[:height] || height0).to_i
    @width = (params[:width] || width0).to_i

    cell_class = params[:cell_status].values

    @maze = {}
    cell_class.each do |c_id, c_cls|
      _, y, x = c_id.split('-').map(&:to_i)
      if c_cls.include? 'cell-wall'
        @maze[[y,x]] = nil
      else
        @maze[[y,x]] = 1
        if c_cls.include? 'cell-start'
          @start = [y,x]
        elsif c_cls.include? 'cell-goal'
          @goal = [y,x]
        end
      end

    end


    # @start = [0,0]
    # @goal = [@height-1, @width-1]

    # base_maze = %w(
    #   .##.......
    #   ..#.###.#.
    #   .##...#.#.
    #   ..#..##.#.
    #   #.#..#..#.
    #   #.#..#..#.
    #   #.#..#..#.
    #   #.#..#..#.
    #   #.#..#..#.
    #   #....#..#.
    #   )
    #
    # @maze = to_maze_hash(base_maze)
    @path = path_with_min_cost(@start, @goal, @maze)

    respond_to do |format|
      format.json do
        render json: {path: @path, params: cell_class, start: @start, goal: @goal, maze: @maze}
      end
    end
  end

end
