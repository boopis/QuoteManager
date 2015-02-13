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
    '</div>'

  $(this).before(field)
  event.preventDefault()

$(document).on 'click', 'form .remove-setting', (event) ->
  $(this).closest('.setting-field').remove()
  event.preventDefault()

$(document).on 'click', 'form .form-field', (event) ->
  $('.form-field.active').removeClass('active')
  $(this).addClass('active')
  bindFormFieldOption($(this))
  event.preventDefault()

bindFormFieldOption = (formField) ->
  props = [
    'css_class'
    'placeholder'
    'description'
    'required'
  ]
  inputType = formField.find('input[id$="type"]').val()

  # Hide placeholder with radio, checkbox, select field
  if inputType == 'radio' or inputType == 'checkbox' or inputType == 'select'
    $('#option_placeholder').parent().hide()
  else
    $('#option_placeholder').parent().show()

  props.forEach (el) ->
    hiddenValue = formField.find('input[data-name$="' + el + '"]').val() 

    if el == 'required'
      checked = if hiddenValue == '1' then true else false
      $('#option_' + el).prop 'checked', checked
    else
      $('#option_' + el).val hiddenValue
    return
  return

ready = ->
  $('.form-field').first().click()
  $('.settings input').change (e) -> 
    propName = $(this).data('name')
    if @type == 'checkbox'
      value = if $(this).is(':checked') then 1 else 0
    else
      value = $(this).val()
    $('.form-field.active').find('input[data-name$="' + propName + '"]').val value
    return
  $('.tabs-wrapper .nav.nav-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab 'show'
    return
  $('.form-field-list').sortable
    distance: 15
  	handle: '.form-field'

$(document).ready(ready)
$(document).on('page:load', ready)
