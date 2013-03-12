#= require turbolinks
#= require components/namespace
#= require components/navigation
#= require components/logo


hasCanvas = ->
  elem = document.createElement 'canvas'
  !!(elem.getContext && elem.getContext('2d'))

changed = (e) ->
  modeset.has_canvas ?= hasCanvas()
  nav = document.querySelector '#navigation .nav'
  modeset.navigation = new modeset.Navigation nav

  # if modeset.has_canvas
    # logo = document.querySelector '#navigation .modeset-crest'
    # modeset.logo = new Logo logo, 46

  _gaq.push(['_trackPageview']) if _gaq


fetched = (e) ->
  modeset.navigation.dispose() if modeset.navigation
  # modeset.logo.dispose() if modeset.logo


if document.addEventListener
  document.addEventListener 'DOMContentLoaded', => changed arguments...
  document.addEventListener 'page:change', => changed arguments...
  document.addEventListener 'page:fetch', => fetched arguments...

