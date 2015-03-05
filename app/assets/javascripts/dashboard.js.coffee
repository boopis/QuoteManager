//= require jquery
//= require smoothscroll

$ ($) ->
  $("#sidebar-nav .dropdown-toggle").click (e) ->
    e.preventDefault()
    $item = $(this).parent()
    unless $item.hasClass("open")
      $item.parent().find(".open .submenu").slideUp "fast"
      $item.parent().find(".open").toggleClass "open"
    $item.toggleClass "open"
    if $item.hasClass("open")
      $item.children(".submenu").slideDown "fast"
    else
      $item.children(".submenu").slideUp "fast"
    return

  # $("#sidebar").affix offset:
  #   top: $("header").height()
