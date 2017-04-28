
get_cost_algorithm = ->
  selected = $('input[name=cost-algorithm]:checked').val()
  if selected == 'min_distance'
    'minimum_distance'
  else if selected == 'min_turns'
    'minimum_turns'
  else
    null

read_cell_status = ->
  cells = $('.cell')
  cell_status = []
  $.each cells, (i, cell) ->
    cell_status.push [cell.id, cell.className]
  cell_status

read_size_settings = ->
  w = $('#maze-width').val()
  h = $('#maze-height').val()
  [h, w]

switch_cell = (cell) ->
  # cell.css 'background-color', '#000'
  $('.cell').removeClass('cell-path')
  if cell.hasClass('cell-wall')
    cell.removeClass('cell-wall')
    cell.addClass('cell-space')
  else
    cell.removeClass('cell-space')
    cell.addClass('cell-wall')

glow_cell = (name) ->
  $(name).addClass 'cell-path'

set_timer_for_glow = (x,y,time) ->
  cell_name = "#cell-#{x}-#{y}"
  setTimeout ->
    glow_cell(cell_name)
  , time

unflash_cells = ->
  $('.cell').removeClass 'cell-flash'

flash_cells = (time) ->
  $('.cell').addClass 'cell-flash'
  setTimeout ->
    unflash_cells()
  , time


redraw_maze = ->
  $('.cell').removeClass('cell-path')
  maze_size = read_size_settings()
  cell_status = read_cell_status()

  $.ajax
    type: 'POST'
    url: 'maze/redraw'
    data: {cell_status: cell_status, height: maze_size[0], width: maze_size[1]}
    dataType: 'json'

  .done (data, textStatus, jqXHR) ->
    console.log("ajax succefully completed");
    $('#maze-body').html(data.maze)
    $('.cell').on 'click', ->
      if !$(this).hasClass('cell-start') and !$(this).hasClass('cell-goal')
        switch_cell($(this))

  .fail (jqXHR, textStatus, errorThrown) ->
    console.log("ajax failed", errorThrown);

animate_path = ->
  $('.cell').removeClass('cell-path')
  maze_size = read_size_settings()
  cell_status = read_cell_status()
  cost_algorithm = get_cost_algorithm()

  $.ajax
    type: 'POST'
    url: 'maze/seek'
    data: {cell_status: cell_status, height: maze_size[0], width: maze_size[1], algorithm: cost_algorithm}
    dataType: 'json'

  .done (data, textStatus, jqXHR) ->
    if data.path == null
      console.log('No paths identified')
      flash_cells 200
    else
      console.log("ajax succefully completed");
      data.path.forEach (pos, i) ->
        set_timer_for_glow(pos[0], pos[1], 40*i)

  .fail (jqXHR, textStatus, errorThrown) ->
    console.log("ajax failed");
    flash_cells 100

ready = ->
  console.log('ready')
  $('.cell').on 'click', ->
    if !$(this).hasClass('cell-start') and !$(this).hasClass('cell-goal')
      switch_cell($(this))
  $('.btn.seek-btn').on 'click', (e) ->
    e.preventDefault()
    animate_path()
  $('.btn.size-change-btn').on 'click', (e) ->
    e.preventDefault()
    redraw_maze()
  $('#maze-body').on 'click', (e) ->
    $('.cell').removeClass('cell-path')


$(document).on 'turbolinks:load', ready
