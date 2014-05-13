$(document).on 'click', 'form .add_fields', (event) ->
  $('.form-field').last().after($(this).data('fields'))
  event.preventDefault()

$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).closest('.form-field').remove()
  event.preventDefault()

$(document).on 'click', 'form .add_options', (event) ->
  $(this).before($(this).data('fields'))
  event.preventDefault()

$(document).on 'click', 'form .remove_options', (event) ->
  $(this).closest('.option-field').remove()
  event.preventDefault()

ready = ->
  $('.form-field-list').sortable ->
  	handle: '.form-field'

$(document).ready(ready)
$(document).on('page:load', ready)