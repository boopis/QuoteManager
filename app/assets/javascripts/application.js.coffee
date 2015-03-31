#= require jquery
#= require bootstrap

slideDropdownMenu = ($item) ->
  if !$item.hasClass('open')
    $item.parent().find('.open .submenu').slideUp 'fast'
    $item.parent().find('.open').toggleClass 'open'
  $item.toggleClass 'open'
  if $item.hasClass('open')
    $item.children('.submenu').slideDown 'fast'
  else
    $item.children('.submenu').slideUp 'fast'
  return

$(document).ready ->
  $('#sidebar-nav .dropdown-toggle').click (e) ->
    $item = $(this).parent()
    slideDropdownMenu $item
    false
  $('.profile-dropdown .dropdown-toggle').click (e) ->
    $item = $(this).parent()
    slideDropdownMenu $item
    false
  $('.collapse-sidebar').click (e) ->
    collBtn = $(this)
    sidebar = $('.sidebar')
    rightContent = $('.content-wrapper .wrapper')
    utilBtn = $('.util-button')
    if collBtn.hasClass('active')
      sidebar.css 'margin-left', '0'
      rightContent.css 'margin-left', '245px'
      collBtn.removeClass 'active'
      utilBtn.addClass 'hidden'
    else
      sidebar.css 'margin-left', '-260px'
      rightContent.css 'margin-left', '0'
      collBtn.addClass 'active'
      utilBtn.removeClass 'hidden'
    false
  $('.util-button').click (e) ->
    utilBtn = $(this)
    sidebar = $('.sidebar')
    rightContent = $('.content-wrapper .wrapper')
    collBtn = $('.collapse-sidebar')
    sidebar.css 'margin-left', '0'
    rightContent.css 'margin-left', '245px'
    collBtn.removeClass 'active'
    utilBtn.addClass 'hidden'
    return
  return
