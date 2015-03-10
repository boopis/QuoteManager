#= require bootstrap
#= require tinymce
#= require zclip
#= require jquery.ui.sortable

$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field-list').append($(this).data('fields').replace(regexp, time))
  reOrderFormFields()
  event.preventDefault()

$(document).on 'click', 'form .add_contact_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.form-field-list').append($(this).data('fields').replace(regexp, time))
  $(this).removeClass('add_contact_fields').addClass('cant_add_fields')
  reOrderFormFields()
  event.preventDefault()

$(document).on 'click', 'form .remove_fields', (event) ->
  field = $(this).closest '.form-field'
  type = field.find('input[data-name="type"]').val()
  window.removingField = field
  window.removingContactType = type
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
  if window.currentField != undefined && $(that)[0] == window.currentField[0]
    return false
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
    'content'
  ]
  inputType = formField.find('input[id$="type"]').val()
  window.currentField = formField
  
  # Show / hide shared field properties
  $('#option_css_class').parent().removeClass('hidden')
  $('#option_label').parent().removeClass('hidden')
  $('#option_required').parent().removeClass('hidden')
  $('#option_placeholder').parent().removeClass('hidden')
  $('#option_id_class').parent().addClass('hidden')
  $('.multi-options').addClass('hidden')
  $('.rich-content').addClass('hidden')

  # Hide placeholder with radio, checkbox, select field
  if inputType == 'radio' or inputType == 'checkbox' or inputType == 'select'
    $('#option_placeholder').parent().addClass('hidden')
    $('.multi-options').removeClass('hidden')
    bindMultiOptionsField()

  if inputType == 'file'
    $('#option_placeholder').parent().addClass('hidden')

  if inputType == 'inpage'
    $('#option_id_class').parent().removeClass('hidden')
    $('#option_placeholder').parent().addClass('hidden')

  if inputType == 'header' 
    $('#option_placeholder').parent().addClass('hidden')
    $('.rich-content').removeClass('hidden')
    $('#option_required').parent().addClass('hidden')
    $('#option_label').parent().addClass('hidden')

  if inputType == 'email'
    $('#option_required').parent().addClass('hidden')
    $('#option_required').val 1

  props.forEach (el) ->
    hiddenValue = formField.find('input[data-name$="' + el + '"]').val() 

    if el == 'required'
      checked = if hiddenValue == '1' then true else false
      $('#option_' + el).prop 'checked', checked
    else if el == 'content'
      if hiddenValue != undefined
        tinyMCE.activeEditor.setContent hiddenValue
    else
      $('#option_' + el).val hiddenValue
    return

  $('.settings .main-box ul').fadeIn()
  return

getRawDataFromEditor = ->
  currentField = window.currentField
  content = currentField.find 'input[data-name="content"]'
  visualField = currentField.find '.content'
  value = tinyMCE.activeEditor.getContent({format : 'raw'})

  content.val value
  visualField.html value

reOrderFormFields = ->
  $lstFormField = $('.form-field-list')
  lstOrder = $lstFormField.sortable('toArray', {attribute: 'data-id'})
  # Re order form field position
  i = 0
  while i < lstOrder.length
    $lstFormField.find('#form_fields_' + lstOrder[i] + '_position').val i
    i++

migrationScript = (ecomType) ->
  script = $ '#list_product_script'
  ecommerce = 
    Shopify:
      btn: '.btn-cart'
      price: '.product_price'
      productItem: '.product'
    WooCommerce:
      btn: '.add_to_cart_button'
      price: '.price'
      productItem: '.product li'
    OpenCart:
      btn: '.cart-button'
      price: '.price'
      productItem: '.product-layout'
    ZenCart:
      btn: '.product-buttons'
      price: '.price'
      productItem: '.product-col'
    Magento:
      btn: '.btn-cart'
      price: '.price-box'
      productItem: '.product-container'
    PrestaShop:
      btn: 'button-container'
      price: 'content_price'
      productItem: '.product-container'
  
  scriptContent = "a = document.querySelectorAll('" + ecommerce[ecomType].productItem + "'); \n" + 
            "for (var i=0; i<a.length; i++) { \n" + 
            "  if ( a[i].querySelector('" + ecommerce[ecomType].price + "').textContent.match(/ 0\./) ) { \n" + 
            "    a[i].querySelector('" + ecommerce[ecomType].btn + "').innerHTML = 'Quote'; \n" +
            "  } \n" +
            "}"

  script.val scriptContent

$("#rendered-form").tooltip({ selector: '[data-toggle=tooltip]' })
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
  reOrderFormFields()
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
$("#js input:radio").change (e) ->
  migrationScript $(this).val() 
  return
$('.form-field-list').sortable
  update: (event, ui) ->
    reOrderFormFields()
    return
  distance: 15
tinymce.init
  selector: '.rich-content textarea'
  menubar : false
  plugins: [
    'visualblocks code fullscreen'
    'table contextmenu paste'
  ]
  setup: (editor) ->
    editor.on 'change', (e) ->
      getRawDataFromEditor()
      return
    editor.on 'keyup', (e) ->
      getRawDataFromEditor() 
      return
    return
  toolbar: 'table | styleselect | bold italic | bullist numlist outdent indent | link image | fullscreen | code'
# Form thank you message
tinymce.init
  selector: '.thank-you-message textarea'
  menubar : false
  plugins: [
    'visualblocks code fullscreen'
    'contextmenu paste'
  ]
  setup: (editor) ->
    editor.on 'change', (e) ->
      return
    editor.on 'keyup', (e) ->
      return
    return
  toolbar: 'styleselect | bold italic | bullist numlist outdent indent | link image | fullscreen | code'

# Pre-init for ui
$('#contact-email').click()
$('.form-field').first().click()
if $("#js input:radio").val() != '' 
  migrationScript 

# Form show page
# Copy inline javascript link
$copyScript = $('a#copy-script')
copyScript = new ZeroClipboard document.getElementById('copy-script')
copyScript.on 'ready', (readyEvent) ->
  copyScript.on 'aftercopy', (event) ->
    $copyScript.text('Copied!').removeClass('btn-primary').addClass('btn-success')
    return
  return

# Copy raw form's HTML 
$copyRawHTML = $('a#copy-raw-html')
copyRawHTML = new ZeroClipboard $copyRawHTML[0] 
copyRawHTML.on 'ready', (readyEvent) ->
  copyRawHTML.on 'aftercopy', (event) ->
    $copyRawHTML.text('Copied!').removeClass('btn-primary').addClass('btn-success')
    return
  return

# Re change title of copy button after user lose focus on it
$copyRawHTML.mouseout (e) -> 
  $copyRawHTML.text('Copy to clipboard').removeClass('btn-success').addClass('btn-primary')
  return

$copyScript.mouseout (e) -> 
  $copyScript.text('Copy to clipboard').removeClass('btn-success').addClass('btn-primary')
  return

$('#rawhtml').val $('form').html()
