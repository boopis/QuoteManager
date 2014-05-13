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

  $(".mobile-search").click (e) ->
    e.preventDefault()
    $(".mobile-search").addClass "active"
    $(".mobile-search form input.form-control").focus()
    return

  $(document).mouseup (e) ->
    container = $(".mobile-search")
    # if the target of the click isn't the container...
    # ... nor a descendant of the container
    container.removeClass "active"  if not container.is(e.target) and container.has(e.target).length is 0
    return

  return

(($, sr) ->
  
  # debouncing function from John Hann
  # http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
  debounce = (func, threshold, execAsap) ->
    timeout = undefined
    debounced = ->
      delayed = ->
        func.apply obj, args  unless execAsap
        timeout = null
        return
      obj = this
      args = arguments_
      if timeout
        clearTimeout timeout
      else func.apply obj, args  if execAsap
      timeout = setTimeout(delayed, threshold or 100)
      return

  
  # smartresize 
  jQuery.fn[sr] = (fn) ->
    (if fn then @bind("resize", debounce(fn)) else @trigger(sr))

  return
) jQuery, "smartresize"