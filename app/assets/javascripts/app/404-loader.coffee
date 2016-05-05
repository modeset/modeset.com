class window.FourOhFourLoader

  constructor: ->
    @init() if hasWebGL


  hasWebGL = do ->
    try
      canvas = document.createElement('canvas')
      return ! !(window.WebGLRenderingContext and (canvas.getContext('webgl') or canvas.getContext('experimental-webgl')))
    catch e
      return false
    return


  init: ->
    if window.Logo3d
      @init404Callback()
    else
      window.init404Callback = @init404Callback
      window.loadRemoteScript('/assets/404.js')


  init404Callback: ->
    # make sure there's only one THREE scene ever created, and stick the canvas back into the DOM if we come back to a 404 page
    if container404 = document.getElementById('bummer-404')
      if !window.logo404
        window.logo404 = new window.Logo3d(container404)
      else
        window.logo404.setActive(true, container404)
