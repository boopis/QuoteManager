#= require application
# Show / hide update form
toggleUpdateForm = (e) ->
  $labels = $ '.profile-user-details-label' 
  $viewValues = $ '.profile-user-details-value' 
  $fields = $ '.detail-profile .form-control'
  $fieldLabels = $ '.detail-profile label'
  $updateImage = $ '.wrapper'
  $submitBtn = $ '.update-profile'

  $editViewBtn = $ '.edit-profile'
  $labels.toggleClass 'hidden'  
  $viewValues.toggleClass 'hidden'
  $fields.toggleClass 'hidden'
  $fieldLabels.toggleClass 'hidden'
  $updateImage.toggleClass 'hidden'
  $submitBtn.toggleClass 'hidden'

  btnText = e.currentTarget.textContent

  if btnText.trim() == 'Edit profile'
    $editViewBtn.html '<i class="fa fa-eye fa-lg"></i> View profile'
  else
    $editViewBtn.html '<i class="fa fa-pencil-square fa-lg"></i> Edit profile'


$('.avatar .btn').click (e) -> 
  $('.avatar input').click()
  return false

$('.company-logo .btn').click (e) ->
  $('.company-logo input').click()
  return false

$('.edit-profile').click (e) ->
  toggleUpdateForm(e)
  return false
