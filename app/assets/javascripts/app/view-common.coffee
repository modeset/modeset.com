class ViewCommon
  constructor: (el, isInitialLoad) ->
    @el = el
    @initScrollables()


  initScrollables: ->
    scrollEls = @el.querySelectorAll('.scrollable')
    @scrollables = []
    # for(i=0 i < scrollEls.length i++) {
    #   @scrollables.push(new Scrollable(scrollEls[i]))


  dispose: ->
    for scrollable in @scrollables
      scrollable.dispose()
    @scrollables.splice(0)

window.ViewCommon = ViewCommon
