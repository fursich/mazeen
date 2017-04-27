
read_cell_status = ->
  cells = $('.cell')
  cell_status = []
  $.each cells, (i, cell) ->
    cell_status.push [cell.id, cell.className]
  cell_status

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

animate_path = ->
  $('.cell').removeClass('cell-path')
  cell_status = read_cell_status()

  $.ajax
    type: 'POST'
    url: 'maze/seek'
    data: {cell_status: cell_status}
    dataType: 'json'
  .done (data, textStatus, jqXHR) ->
    console.log("ajax succefully completed");
    data.path.forEach (pos, i) ->
      set_timer_for_glow(pos[0], pos[1], 40*i)
    read_cell_status()

  .fail (jqXHR, textStatus, errorThrown) ->
    console.log("ajax failed");

ready = ->
  console.log('ready')
  $('.cell').on 'click', ->
    if !$(this).hasClass('cell-start') and !$(this).hasClass('cell-goal')
      switch_cell($(this))
  $('.btn.seek-btn').on 'click', (e) ->
    e.preventDefault()
    animate_path()
  $('#maze-body').on 'click', (e) ->
    $('.cell').removeClass('cell-path')


$(document).on 'turbolinks:load', ready
