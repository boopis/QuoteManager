#= require application
#= require tinymce
tinymce.init
  selector: '#template_content'
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
