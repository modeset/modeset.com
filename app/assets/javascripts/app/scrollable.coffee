class Scrollable

  constructor: (el) ->
    @el = el
    @showing = false
    @clientRect = null
    @updateScroll()

  updateScroll: ->
    @clientRect = @el.getBoundingClientRect()
    if (@clientRect.bottom > window.innerHeight && @clientRect.top > window.innerHeight) || (@clientRect.bottom < 0 && @clientRect.top < 0)
      @showing = false
      # @el.classList.remove('showing')
    else if @showing == false
      @showing = true
      @el.classList.add('showing')

  dispose: ->


window.Scrollable = Scrollable
