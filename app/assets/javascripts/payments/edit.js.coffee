#= require application

$('#update_payment').submit ->
  $('input[type=submit]').attr 'disabled', true
  $('.spinner-outer-wrapper').show()
  return
