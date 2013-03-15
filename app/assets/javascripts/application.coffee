#= require turbolinks
#= require components/namespace
#= require components/logo

hasCanvas = ->
  elem = document.createElement 'canvas'
  !!(elem.getContext && elem.getContext('2d'))

changed = (e) ->
  modeset.has_canvas ?= hasCanvas()
  if modeset.has_canvas
    logo = document.querySelector '#navigation .modeset-crest'
    modeset.logo = new Logo logo, 46
  _gaq.push(['_trackPageview']) if _gaq


fetched = (e) ->
  modeset.logo.dispose() if modeset.logo


if document.addEventListener
  document.addEventListener 'DOMContentLoaded', => changed arguments..., false
  document.addEventListener 'page:change', => changed arguments..., false
  document.addEventListener 'page:fetch', => fetched arguments..., false

