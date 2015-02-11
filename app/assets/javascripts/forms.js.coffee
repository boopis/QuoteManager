$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field').last().after($(this).data('fields').replace(regexp, time))
  event.preventDefault()

$(document).on 'click', 'form .add_contact_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field').last().after($(this).data('fields').replace(regexp, time))
  $(this).removeClass('add_contact_fields').addClass('cant_add_fields')
  event.preventDefault()

$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).closest('.form-field').remove()
  event.preventDefault()

$(document).on 'click', 'form .remove_contact_fields', (event) ->
  $(this).closest('.form-field').remove()
  $id = $(this).attr('id')
  $('#'+$id).removeClass('cant_add_fields').addClass('add_contact_fields')
  event.preventDefault()

$(document).on 'click', 'form .add_options', (event) ->
  $(this).before($(this).data('fields'))
  event.preventDefault()

$(document).on 'click', 'form .remove_options', (event) ->
  $(this).closest('.option-field').remove()
  event.preventDefault()

$(document).on 'click', 'form .add_setting', (event) ->
  $(this).before($(this).data('fields'))
  event.preventDefault()

$(document).on 'click', 'form .remove_setting', (event) ->
  $(this).closest('.option-field').remove()
  event.preventDefault()


ready = ->
  $('.tabs-wrapper .nav.nav-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab 'show'
    return
  $('.form-field-list').sortable
    distance: 15
  	handle: '.form-field'

$(document).ready(ready)
$(document).on('page:load', ready)
