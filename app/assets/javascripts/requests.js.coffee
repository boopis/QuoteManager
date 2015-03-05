#= require shared
$('[data-toggle="tooltip"]').tooltip()
$('tr.chiffon-bg').click (e) ->
  $(this).next().slideToggle('fast')
  return
