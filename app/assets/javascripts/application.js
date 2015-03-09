//= require jquery
//= require bootstrap/transition
//= require bootstrap/collapse
//= require smoothscroll

function slideDropdownMenu ($item) {

  if (!$item.hasClass("open")) {
    $item.parent().find(".open .submenu").slideUp("fast");
    $item.parent().find(".open").toggleClass("open");
  }
  $item.toggleClass("open");
  if ($item.hasClass("open")) {
    $item.children(".submenu").slideDown("fast");
  } else {
    $item.children(".submenu").slideUp("fast");
  }
}

$( document ).ready(function() {
  $("#sidebar-nav .dropdown-toggle").click(function(e) {
    var $item = $(this).parent();

    slideDropdownMenu($item);

    return false;
  });

  $(".profile-dropdown .dropdown-toggle").click(function(e) {
    var $item = $(this).parent();

    slideDropdownMenu($item);

    return false;
  });
});
