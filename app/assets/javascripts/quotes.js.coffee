$(document).ready ->
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
