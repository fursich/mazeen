class MazeController < ApplicationController
  include MinCost

  def index
    height0, width0 = 10,10

    @height = (params[:height] || height0).to_i
    @width = (params[:width] || width0).to_i
    @start = start_pos
    @goal = goal_pos

    @maze = to_maze_hash(base_maze)
  end

  def redraw
    redirect_to action: :index and return unless get_state_from_json
    redirect_to action: :index and return unless (params[:height] && params[:width])

    @height = params[:height].to_i
    @width = params[:width].to_i
    @start = start_pos
    @goal = goal_pos

    maze_body = render_to_string partial: 'maze/maze', locals: {height: @height, width: @width, maze: @maze, start: @start, goal: @goal}
    render json: {maze: maze_body}
  end

  def seek
    redirect_to action: :index and return unless get_state_from_json
    redirect_to action: :index and return unless params[:algorithm]
    cost_algorithm = params[:algorithm].to_sym

    # @path = path_with_min_cost(@start, @goal, @maze, algorithm: :minimum_distance)
    @path = path_with_min_cost(@start, @goal, @maze, algorithm: cost_algorithm)

    respond_to do |format|
      format.json do
        render json: {path: @path, start: @start, goal: @goal, maze: @maze, algo: cost_algorithm}
      end
    end
  end


  private

    def base_maze
      %w(
      .##.......
      ..#.###.#.
      .##...#.#.
      ..#..##.#.
      #.#..#..#.
      #.#..#....
      #.#..#.##.
      ..#..#..#.
      .#...##.#.
      ...#....#.
      )
    end
    def start_pos
      @start = [0,0]
    end
    def goal_pos
      @goal = [@height-1, @width-1]
    end

    def get_state_from_json
      return nil unless (params[:height] && params[:width] && params[:cell_status])

      @height = params[:height].to_i
      @width = params[:width].to_i
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

      @maze
    end

end
