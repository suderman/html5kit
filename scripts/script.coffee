###!

88                                    88 8888888888  88        88
88           ,d                       88 88          88        ""   ,d
88           88                       88 88  ____    88             88
88,dPPYba, MM88MMM 88,dPYba,,adPYba,  88 88a8PPPP8b, 88   ,d8  88 MM88MMM
88P'    "8a  88    88P'   "88"    "8a 88 PP"     `8b 88 ,a8"   88   88
88       88  88    88      88      88 88          d8 8888[     88   88
88       88  88,   88      88      88 88 Y8a     a8P 88`"Yba,  88   88,
88       88  "Y888 88      88      88 88  "Y88888P"  88   `Y8a 88   "Y888

                                                      ;-)###
# ----------------------------------------------------------

# Override paths to assets
yepnope.paths =
  'scripts': 'scripts'
  'styles': 'styles'

# CSS3 selector support & stylesheet reset 
# (selectivizr only works on same-domain stylesheets)
yepnope test: Modernizr.ie <= 8, yep: 'scripts/ie.js'
yepnope test: Modernizr.ie <= 7, yep: 'styles/ie.css'

# Gentlemen, load your libraries
yepnope load: [
  'scripts/lib/jquery.js'         # obviously
  'scripts/lib/underscore.js'     # tasty utility methods
  'scripts/lib/fastclick.js'      # treat tap as click events
  'scripts/lib/H5F.js'            # HTML5 forms polyfill
], complete: -> jQuery app.init()

# Google Analytics
window._gaq = [["_setAccount", "XX-XXXXXXXX-X"], ["_trackPageview"], ["_trackPageLoadTime"]]
yepnope load: 'http://www.google-analytics.com/ga.js'

# All site behavior right here folks!
window.app = {}

app.init = ->
  app.setup()
  app.navigation()
  $('html').addClass 'ready'

app.setup = ->

  # Treat clicks as taps on touch devices
  new FastClick document.body

  # Enable form placeholder on lazy browsers
  $('form').each -> H5F.setup(this)

  # Ruby-style string interpolation #{...}
  _.templateSettings = interpolate: /\#\{(.+?)\}/g

  # Turn http://, @usernames and #hashtags into links
  _.mixin
    linkify: (string) ->
      string = string.replace /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig, "<a target='_blank' href='$1'>$1</a>"
      string = string.replace /(^|\s)@(\w+)/g, "$1<a target='_blank' href='http://www.twitter.com/$2'>@$2</a>"
      string = string.replace /(^|\s)#(\w+)/g, "$1<a target='_blank' href='http://search.twitter.com/search?q=%23$2'>#$2</a>"

  # Cross-browser support for CSS transition callback
  app.transitionEnd = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend'


app.navigation = ->

  # Reveal side menu
  $('header[role=banner] a.menu').on 'click', (e)->

    # Don't allow real click event (hash in url)
    e.preventDefault()

    # Don't trigger the 'html.menu' click event
    e.stopPropagation()

    # Slide the side menu in
    $('html').toggleClass 'menu'


  # Hide the side menu
  $(document).on 'click', 'html.menu', (e)->

    # Check for clicking a link in the menu itself
    unless $(e.target).parents('nav[role=navigation]').length
      $('html').removeClass 'menu'


  # Open/close behaviour in side menu
  $('nav[role=navigation] > ul > li > a').on 'click', (e)->
    e.preventDefault()

    # On first click, expand the submenu
    $nav = $(this).next 'nav'
    if $nav.height() is 0
      $nav.closest('ul').find('> li > nav').height 0
      $nav.height $nav.find('ul:first').height()
      $nav.hide().show()

    # On second click, follow the link
    else 
      # location.href = this.href
      $('html').removeClass 'menu'
      href = $(this).attr('href')
      $('html, body').animate 
        scrollTop: $(href).offset().top
        , 500, -> window.location.hash = href

  # Swipe to/from menu
  $(document).on 'swipe', (e)-> 
    $('html').addClass 'menu' if e.direction is 'left'
    $('html').removeClass 'menu' if e.direction is 'right'

  # # Set navigation height to match html height (when in menu mode)
  # $(window).resize -> $('nav[role=navigation]').height $('html').height() * 1.3
  # $(window).resize()
