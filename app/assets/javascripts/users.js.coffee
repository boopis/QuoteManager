# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $labels = $ '.profile-user-details-label' 
  $viewValues = $ '.profile-user-details-value' 
  $fields = $ '.form-control'
  $fieldLabels = $ 'label'

  $('.avatar .btn').click (e) -> 
    $('.avatar input').click()
    return false

  $('.edit-profile').click (e) ->
    $editViewBtn = $ '.edit-profile'
    $labels.toggleClass 'hidden'  
    $viewValues.toggleClass 'hidden'
    $fields.toggleClass 'hidden'
    $fieldLabels.toggleClass 'hidden'

    btnText = e.currentTarget.textContent

    if btnText.trim() == 'Edit profile'
      $editViewBtn.html '<i class="fa fa-pencil-square fa-lg"></i> View profile'
    else
      $editViewBtn.html '<i class="fa fa-pencil-square fa-lg"></i> Edit profile'

    return false
  return
$(document).ready(ready)
