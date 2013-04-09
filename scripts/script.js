/*!

88                                    88 8888888888  88        88
88           ,d                       88 88          88        ""   ,d
88           88                       88 88  ____    88             88
88,dPPYba, MM88MMM 88,dPYba,,adPYba,  88 88a8PPPP8b, 88   ,d8  88 MM88MMM
88P'    "8a  88    88P'   "88"    "8a 88 PP"     `8b 88 ,a8"   88   88
88       88  88    88      88      88 88          d8 8888[     88   88
88       88  88,   88      88      88 88 Y8a     a8P 88`"Yba,  88   88,
88       88  "Y888 88      88      88 88  "Y88888P"  88   `Y8a 88   "Y888

                                                      ;-)
*/

yepnope.paths = {
  'scripts': 'scripts',
  'styles': 'styles'
};

yepnope({
  test: Modernizr.ie <= 8,
  yep: 'scripts/ie.js'
});

yepnope({
  test: Modernizr.ie <= 7,
  yep: 'styles/ie.css'
});

yepnope({
  load: ['scripts/jquery.js', 'scripts/underscore.js', 'scripts/fastclick.js', 'scripts/H5F.js'],
  complete: function() {
    return jQuery(app.init());
  }
});

window._gaq = [["_setAccount", "XX-XXXXXXXX-X"], ["_trackPageview"], ["_trackPageLoadTime"]];

yepnope({
  load: 'http://www.google-analytics.com/ga.js'
});

window.app = {};

app.init = function() {
  app.setup();
  app.navigation();
  return $('html').addClass('ready');
};

app.setup = function() {
  new FastClick(document.body);
  $('form').each(function() {
    return H5F.setup(this);
  });
  _.templateSettings = {
    interpolate: /\#\{(.+?)\}/g
  };
  _.mixin({
    linkify: function(string) {
      string = string.replace(/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig, "<a target='_blank' href='$1'>$1</a>");
      string = string.replace(/(^|\s)@(\w+)/g, "$1<a target='_blank' href='http://www.twitter.com/$2'>@$2</a>");
      return string = string.replace(/(^|\s)#(\w+)/g, "$1<a target='_blank' href='http://search.twitter.com/search?q=%23$2'>#$2</a>");
    }
  });
  return app.transitionEnd = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend';
};

app.navigation = function() {
  $('header[role=banner] a.menu').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    return $('html').toggleClass('menu');
  });
  $(document).on('click', 'html.menu', function(e) {
    if (!$(e.target).parents('nav[role=navigation]').length) {
      return $('html').removeClass('menu');
    }
  });
  $('nav[role=navigation] > ul > li > a').on('click', function(e) {
    var $nav, href;
    e.preventDefault();
    $nav = $(this).next('nav');
    if ($nav.height() === 0) {
      $nav.closest('ul').find('> li > nav').height(0);
      $nav.height($nav.find('ul:first').height());
      return $nav.hide().show();
    } else {
      $('html').removeClass('menu');
      href = $(this).attr('href');
      return $('html, body').animate({
        scrollTop: $(href).offset().top
      }, 500, function() {
        return window.location.hash = href;
      });
    }
  });
  return $(document).on('swipe', function(e) {
    if (e.direction === 'left') {
      $('html').addClass('menu');
    }
    if (e.direction === 'right') {
      return $('html').removeClass('menu');
    }
  });
};

