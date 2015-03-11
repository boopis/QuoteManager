#= require bootstrap
#= require moment
#= require bootstrap-datetimepicker
#= require jSignature
#= require tagsinput
#= require tinymce

sigdiv = $("#signature").jSignature {'UndoButton':true}
sigdiv.bind 'change', (event) ->
  # Set style for undo last stroke button
  $('#signature input').css 'top', '20px'
  return
$('#accept').click (event) -> 
  $('#sig').val sigdiv.jSignature("getData","svgbase64")[1]
  return

  # $("#quote_expires_at").datepicker
  #   format: "yyyy-mm-dd"
  #   todayHighlight: true
  #   startDate: "today",
  #   autoclose: true

$ ->
  today = new Date()
  dd = today.getDate()
  mm = today.getMonth()+1
  yyyy = today.getFullYear()
  today = mm+'/'+dd+'/'+yyyy;

  $("#quote_expires_at").datetimepicker
    minDate: today

$(document).on 'click', 'form .add_quote_options', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.quote-option-field').last().after($(this).data('options').replace(regexp, time))
  event.preventDefault()

$(document).on 'click', 'form .remove_quote_options', (event) ->
  $(this).closest('.quote-option-field').remove()
  event.preventDefault()

$quoteEmail = $ '#send-quote'
tinymce.init
  selector: '#send-quote'
  menubar : false
  plugins: [
    'visualblocks code fullscreen'
    'contextmenu paste'
  ]
  setup: (editor) ->
    editor.on 'change', (e) ->
      $quoteEmail.val $(this)[0].getContent({ format: 'raw' }) 
      return
    editor.on 'keyup', (e) ->
      $quoteEmail.val $(this)[0].getContent({ format: 'raw' }) 
      return
    return
  toolbar: 'styleselect | bold italic | bullist numlist outdent indent | link image | fullscreen | code'

$('#insert-quote-link').click (e) -> 
  tinyMCE.activeEditor.dom.add tinyMCE.activeEditor.getBody(), 'a', { href: (window.location.origin + $(this).data('quote')) }, 'public quote link'
  return false

$emailAddress = $ '#email'
$emailAddress.on 'itemAdded', (e) ->
  return
$emailAddress.on 'itemRemoved', (e) ->
  return
