#= require 'jquery'

account = undefined
jQuery ->
  account.setupForm()
account =
  setupForm: ->
    $('#new_payment').submit ->
      $('input[type=submit]').attr 'disabled', true
      $('.spinner-outer-wrapper').show()
      if $('#card_number').length
        account.processCard()
        false
      else
        true
  processCard: ->
    card = undefined
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken card, account.handleStripeResponse
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#stripe_card_token').val response.id
      $('#new_payment')[0].submit()
    else
      $('input[type=submit]').attr 'disabled', false
      $('.spinner-outer-wrapper').hide()
      $('#stripe_error').text(response.error.message).css
        'padding': '20px'
        'border-radius': '7px'
