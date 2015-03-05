ready = ->
  $('[data-toggle="tooltip"]').tooltip()
  $('tr.chiffon-bg').click (e) ->
    $(this).next().slideToggle('fast')
    return

$(document).ready(ready)
$(document).on('page:load', ready)
