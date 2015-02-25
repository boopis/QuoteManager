$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field-list').append($(this).data('fields').replace(regexp, time))
  event.preventDefault()

$(document).on 'click', 'form .add_contact_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field-list').append($(this).data('fields').replace(regexp, time))
  $(this).removeClass('add_contact_fields').addClass('cant_add_fields')
  event.preventDefault()

$(document).on 'click', 'form .remove_fields', (event) ->
  removeField this 
  event.preventDefault()

$(document).on 'click', 'form .remove_contact_fields', (event) ->
  field = $(this).closest '.form-field'
  type = field.find('input[data-name="type"]').val()
  window.removingField = field
  window.removingContactType = type
  event.preventDefault()

$(document).on 'click', 'form .add_options', (event) ->
  $(this).before($(this).data('fields'))
  event.preventDefault()

$(document).on 'click', 'form .remove_options', (event) ->
  $(this).closest('.option-field').remove()
  multiOptionsChanged()
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
  that = this
  $('.form-field.active').removeClass('active')
  $(this).addClass('active')
  $('.settings .main-box ul').fadeOut 'fast', ->
    bindFormFieldOption($(that))
    return
  event.preventDefault()

$(document).on 'keyup', '.multi-options .form-control', (event) ->
  multiOptionsChanged()

multiOptionsChanged = ->
  options = []
  currentField = window.currentField
  inputType = currentField.find('input[id$="type"]').val()
  optionsHiddenField = currentField.find('input[data-name$="options"]')
  optionTemp = ''
  value = undefined
  newOptions = ''
  optionsField = $('.multi-options .option-field')
  i = 0

  while i < optionsField.length
    value = $(optionsField[i]).find('.form-control').val()
    if inputType == 'radio'
      optionTemp = '<span>' + value + '</span><input id="name_1" name="name" type="radio" value="' + value + '">'
    else if inputType == 'checkbox'
      optionTemp = '<input id="name_1" name="name" type="checkbox" value="' + value + '">' + '<span>' + value + '</span>'
    else if inputType == 'select'
      optionTemp = '<option value="' + value + '">' + value + '</option>'
    options.push name: value
    newOptions += optionTemp
    i++

  if inputType == 'select'
    newOptions = '<select><option value="">Select Option</option>' + newOptions + '</select>'
  optionsHiddenField.val JSON.stringify(options)
  window.currentField.find('.input-group').html $(newOptions)

  return
 

bindMultiOptionsField = ->
  currentField = window.currentField
  options = currentField.find('input[data-name$="options"]').val()
  if options == ""
    options = []
  else
    options = JSON.parse(options)
  inputType = currentField.find('input[id$="type"]').val()
  addOptionLink = $('.add_options')
  newOption = undefined
  i = 0

  # clear old option field
  $('.multi-options .option-field').remove()

  while i < options.length
    newOption = $(addOptionLink.data('fields'))
    newOption.find('input').val options[i]['name']
    $(addOptionLink).before newOption
    i++

  return

bindFormFieldOption = (formField) ->
  props = [
    'css_class'
    'placeholder'
    'description'
    'required'
    'label'
  ]
  inputType = formField.find('input[id$="type"]').val()
  window.currentField = formField

  # Hide placeholder with radio, checkbox, select field
  if inputType == 'radio' or inputType == 'checkbox' or inputType == 'select'
    $('#option_placeholder').parent().addClass('hidden')
    $('.multi-options').removeClass('hidden')
    bindMultiOptionsField()
  else
    $('#option_placeholder').parent().removeClass('hidden')
    $('.multi-options').addClass('hidden')

  if inputType == 'inpage'
    $('#option_id_class').parent().removeClass('hidden')
    $('#option_placeholder').parent().addClass('hidden')
  else  
    $('#option_placeholder').parent().removeClass('hidden')
    $('#option_id_class').parent().addClass('hidden')

  props.forEach (el) ->
    hiddenValue = formField.find('input[data-name$="' + el + '"]').val() 

    if el == 'required'
      checked = if hiddenValue == '1' then true else false
      $('#option_' + el).prop 'checked', checked
    else
      $('#option_' + el).val hiddenValue
    return

  $('.settings .main-box ul').fadeIn()
  return

ready = ->
  $('.form-field').first().click()
  $("body").tooltip({ selector: '[data-toggle=tooltip]' })
  $("#style input:radio").change (e) ->
    $('.form-field-list').removeClass('column column1 column2').addClass('column' + $(this).val())
  $('#form_name').keyup (e) ->
    $('.form-header b').text $(this).val()
    return
  $('#confirm-delete').on 'show.bs.modal', (e) ->
    $(this).find('.danger').attr 'href', $(e.relatedTarget).data('href')
    $('.debug-url').html 'Delete URL: <strong>' + $(this).find('.danger').attr('href') + '</strong>'
    return
  $('#confirm-delete').find('.modal-footer .yes').on 'click', ->
    $('#confirm-delete').modal('hide');
    $('#contact-' + window.removingContactType).removeClass('cant_add_fields').addClass('add_contact_fields')
    window.removingField.remove()
    window.removingField = null
    window.removingContactType = ''
    return
  $('.settings input:checkbox').change (e) -> 
    propName = $(this).data('name')
    value = if $(this).is(':checked') then 1 else 0
    $('.form-field.active').find('input[data-name$="' + propName + '"]').val value
    if value
      window.currentField.find('label').addClass('required')
    else 
      window.currentField.find('label').removeClass('required')
    return
  $('.settings input').keyup (e) -> 
    propName = $(this).data('name')
    value = $(this).val()
    $('.form-field.active').find('input[data-name$="' + propName + '"]').val value

    if propName == 'placeholder'
      window.currentField.find('.form-control').attr('placeholder', value)
    else if propName == 'label'
      window.currentField.find('label').text(value)
    return
  $('.tabs-wrapper .nav.nav-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab 'show'
    return
  $('.form-field-list').sortable
    distance: 15
  	handle: '.form-field'
  tinymce.init
    selector: '.rich-content textarea'
    menubar : false
    plugins: [
      'visualblocks code fullscreen'
      'insertdatetime table contextmenu paste'
    ]
    toolbar: 'table | styleselect | bold italic | bullist numlist outdent indent | link image | fullscreen | code'

$(document).ready(ready)
$(document).on('page:load', ready)
