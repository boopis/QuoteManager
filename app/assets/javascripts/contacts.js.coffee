#= require bootstrap
#= require notes

socialType = $('.social-type')
btnSocial = $('.btn-social')
inputs = $('.inputs')

# Choose social type
$('.social-list a').click (e) ->
  socialType.text $(this).text() 
  btnSocial.removeClass 'open'
  return false

# Remove one social field
inputs.on 'click', '.remove-social-item', (event) ->
  $(this).parent().remove()
  return

$('#add-new-social').click (e) ->
  type = socialType.text().toLowerCase()

  if $('.fa-' + type + '-square').length > 0
    return false

  newSocialField = '' + 
    '<div class="input-group">' +
      '<span class="input-group-addon">' +
        '<i class="fa fa-' + type + '-square"></i>' +
      '</span>' +
      '<input class="form-control" name="contact[social_media][' +  type + '][user]" type="text" placeholder="Enter your username">' +
      '<input class="form-control" name="contact[social_media][' +  type + '][url]" type="text" placeholder="Enter your social media url">' +
      '<span class="remove-social-item">' +
        '<i class="fa fa-minus-circle"></i>' +
      '</span>' +
    '<div>'
  inputs.append $(newSocialField)

  return false
