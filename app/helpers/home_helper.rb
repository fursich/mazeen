module HomeHelper

  def cell_type(h, w)
    return 'cell-start'  if [h, w] == @start
    return 'cell-goal' if [h, w] == @goal

    case @maze[[h, w]]
    when nil
      'cell-wall'
    when 1
      'cell-space'
    end
  end

  def cell_icon(h, w)
    return 'glyphicon glyphicon-log-in cell-icon-start'  if [h, w] == @start
    return 'glyphicon glyphicon-log-out cell-icon-goal' if [h, w] == @goal

    case @maze[[h, w]]
    when nil
      'cell-icon-wall'
    when 1
      'cell-icon-space'
    end
  end

end
