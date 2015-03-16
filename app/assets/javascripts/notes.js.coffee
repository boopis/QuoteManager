noteForm = $ '.modal form' 
noteTitle = noteForm.find 'input[id$="title"]'
noteContent = noteForm.find 'textarea[id$="content"]'

$('.create-note').click (e) ->
  
  # Update form action id
  noteForm.attr 'action', $(this).data('action')
  noteTitle.val $(this).data('title') 
  noteContent.val $(this).data('content')

  $('#note-modal').modal 'show'
  return

$('.save-note').on 'click', ->
  $('#note-modal').modal('hide');
  noteForm.submit()
  return
