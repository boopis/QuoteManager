#= require application
#= require jquery_ujs
#= require notes

$('[data-toggle="tooltip"]').tooltip()
$('tr.chiffon-bg').click (e) ->
  $(this).next().slideToggle('fast')
  return
