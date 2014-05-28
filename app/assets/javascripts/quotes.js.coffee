$(document).ready ->

  # $("#quote_expires_at").datepicker
  #   format: "yyyy-mm-dd"
  #   todayHighlight: true
  #   startDate: "today",
  #   autoclose: true

$ ->
  $("#datetimepicker1").datetimepicker 
    language: "pt-BR"

$(document).on 'click', 'form .add_terms', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $('.term-field').last().after($(this).data('terms').replace(regexp, time))
  event.preventDefault()

$(document).on 'click', 'form .remove_terms', (event) ->
  $(this).closest('.term-field').remove()
  event.preventDefault()