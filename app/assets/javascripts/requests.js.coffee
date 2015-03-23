#= require application
#= require notes

$('[data-toggle="tooltip"]').tooltip()
$('tr.chiffon-bg').click (e) ->
  $(this).next().slideToggle('fast')
  return
