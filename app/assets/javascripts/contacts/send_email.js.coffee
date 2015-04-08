#= require application
#= require tinymce

$contactEmail = $ '#email_content'

tinymce.init
  selector: '#email_content'
  menubar : false
  plugins: [
    'visualblocks code fullscreen'
    'contextmenu paste'
  ]
  setup: (editor) ->
    editor.on 'change', (e) ->
      $contactEmail.val $(this)[0].getContent({ format: 'raw' }) 
      return
    editor.on 'keyup', (e) ->
      $contactEmail.val $(this)[0].getContent({ format: 'raw' }) 
      return
    return
  toolbar: 'styleselect | bold italic | bullist numlist outdent indent | link image | fullscreen | code'

$('.email-template').hide()
$('#send_method').change (e) ->
  if $(this).val() == 'Use Template'
    $('.new-content').hide()
    $('.email-template').show()
  else
    $('.new-content').show()
    $('.email-template').hide()
  return
