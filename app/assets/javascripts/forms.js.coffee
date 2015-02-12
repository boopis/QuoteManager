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

$(document).on 'click', 'form .add-setting', (event) ->
  type = $(this).data('type')
  field = '<div class="setting-field"> \n' + 
    '<div class="field"> \n' + 
    '<input class="form-control" placeholder="Enter your ' + type + '"' +
    ' id="form_' + type + 's" name="form['+ type + 's][][' + type + ']">' +
    '<a href="#" class="remove-setting"> \n' + 
    '<i class="fa fa-minus-circle"></i> \n' +
    'Remove ' + type + '</a> \n' +
    '</div> \n' + 
    '</div>';

  $(this).before(field)
  event.preventDefault()

$(document).on 'click', 'form .remove-setting', (event) ->
  $(this).closest('.setting-field').remove()
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
