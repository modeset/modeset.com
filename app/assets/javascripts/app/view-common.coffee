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

  initScrollables: ->
    scrollEls = @el.querySelectorAll('.scrollable')
    # @scrollables = []
    # for(i=0 i < scrollEls.length i++) {
    #   @scrollables.push(new Scrollable(scrollEls[i]))


  dispose: ->
    window.embetter.utils.disposePlayers()
    # for scrollable in @scrollables
    #   scrollable.dispose()
    # @scrollables.splice(0)

window.ViewCommon = ViewCommon
