class ViewCommon

  mediaServices = [
    window.embetter.services.youtube,
    window.embetter.services.vimeo,
    window.embetter.services.codepen
  ]

  constructor: (el, isInitialLoad) ->
    @el = el
    @initScrollables()
    window.embetter.utils.initMediaPlayers(@el, mediaServices)
    @initMap()
    @init404()


  initMap: ->
    if mapEl = document.getElementById('map')
      new Map()


  init404: ->
    if document.getElementById('bummer-404')
      new FourOhFourLoader()



  # fade in main content blocks as you scroll to them
  initScrollables: ->
    window.addEventListener('scroll', @onScroll)
    scrollEls = @el.querySelectorAll('section')
    @scrollables = []
    for el in scrollEls
      @scrollables.push(new Scrollable(el))


  disposeScrollables: ->
    for scrollable in @scrollables
      scrollable.dispose()
    @scrollables.splice(0)


  onScroll: =>
    for scrollable in @scrollables
      scrollable.updateScroll()


  # clean up view
  dispose: ->
    window.embetter.utils.disposePlayers()
    if window.logo404 && window.logo404.active == true
      window.logo404.setActive(false)
    @disposeScrollables()


window.ViewCommon = ViewCommon
