//= require jquery
//= require bootstrap
//= require smoothscroll

$("#sidebar-nav .dropdown-toggle").click(function(e) {
  var $item;
  e.preventDefault();
  $item = $(this).parent();
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
});
