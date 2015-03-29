#= require jquery
#= require smoothscroll
#= require bootstrap/transition
#= require bootstrap/collapse

$form = $ 'form'

$form.submit ->
  $.ajax
    url: $('form').attr('action')
    type: 'POST'
    data: $('form').serialize()
    success: ->
      alert "Thanks, we'll get back to you soon!"
      $form[0].reset()
      return false
  false
