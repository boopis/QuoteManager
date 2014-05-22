$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field').last().after($(this).data('fields').replace(regexp, time))
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