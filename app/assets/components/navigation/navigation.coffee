#= require components/namespace

class modeset.Navigation
  constructor: (@el, data) ->
    @initialize()
    @addListeners()


  initialize: ->
    @lists = @el.find('li').not '.logotype'
    @links = @lists.find '> a'
    @jibs = @jibbers()


  jibbers: ->
    $('<div class="jib"></div>').appendTo @lists
    @el.find '.jib'


  addListeners: ->
    @links.on 'mouseover.navigation', => @mouseover arguments...
    @links.on 'mouseout.navigation', => @mouseout arguments...


  removeListeners: ->
    @links.off 'mouseover.navigation mouseout.navigation'


  mouseover: (e) ->
    $(e.target).closest('li').addClass 'over'


  mouseout: (e) ->
    $(e.target).closest('li').removeClass 'over'


utensils.Bindable.register 'navigation', modeset.Navigation

