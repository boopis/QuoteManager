//= require jquery
//= require bootstrap

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
  $("#sidebar-nav .dropdown-toggle").click(function (e) {
    var $item = $(this).parent();

    slideDropdownMenu($item);

    return false;
  });

  $(".profile-dropdown .dropdown-toggle").click(function (e) {
    var $item = $(this).parent();

    slideDropdownMenu($item);

    return false;
  });

  $(".collapse-sidebar").click(function (e) {

    var collBtn = $(this),
        sidebar = $('.sidebar'),
        rightContent = $('.content-wrapper .wrapper'),
        utilBtn = $('.util-button');

    if (collBtn.hasClass('active')) {
      
      sidebar.css('margin-left', '0');
      rightContent.css('margin-left', '245px');
      collBtn.removeClass('active');
      utilBtn.addClass('hidden');
    } else {

      sidebar.css('margin-left', '-260px');
      rightContent.css('margin-left', '0');
      collBtn.addClass('active');
      utilBtn.removeClass('hidden');
    }

    return false;
  });

  $('.util-button').click(function (e) {

    var utilBtn = $(this),
        sidebar = $('.sidebar'),
        rightContent = $('.content-wrapper .wrapper'),
        collBtn = $('.collapse-sidebar');

    sidebar.css('margin-left', '0');
    rightContent.css('margin-left', '245px');
    collBtn.removeClass('active');
    utilBtn.addClass('hidden');

  });
});
