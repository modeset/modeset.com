#= require components/namespace

class modeset.Navigation
  constructor: (@el, data) ->
    @initialize()
    @addListeners()


  initialize: ->
    @lists = @el.querySelectorAll 'li'
    @links = @el.querySelectorAll 'li > a > span'
    @jibs = @jibbers()


  dispose: ->
    @removeListeners()


  jibbers: ->
    jibs = []
    for list in @lists
      jibs.push(list.appendChild(@render()))
    jibs


  addListeners: ->
    for link in @links
      link.addEventListener 'mouseover', => @mouseover arguments...
      link.addEventListener 'mouseout', => @mouseout arguments...


  removeListeners: ->
    for link in @links
      link.removeEventListener 'mouseover', @mouseover
      link.removeEventListener 'mouseout', @mouseout


  mouseover: (e) ->
    li = e.target.parentNode.parentNode
    li.classList.add 'over' if li


  mouseout: (e) ->
    li = e.target.parentNode.parentNode
    li.classList.remove 'over' if li


  render: ->
    div = document.createElement 'div'
    div.className = 'jib'
    div

