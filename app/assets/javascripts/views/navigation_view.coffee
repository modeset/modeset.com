class modeset.NavigationView extends Backbone.View

  el: 'body'

  events:
    "click .internal": 'clicked'

  constructor: ->
    super
    @indexes = {}
    @internals = @$el.find '.internal'
    @internalish = @$el.find '.internalish'
    @listings = @internals.parent 'li'
    @activate()


  render: (route) ->
    @discharge() unless @is_discharged
    @listings.removeClass 'active'
    @listings.eq(@indexed(route)).addClass 'active'
    @


  dispose: ->
    @undelegateEvents()


  clicked: (e) ->
    e.preventDefault()
    @trigger 'click:internal', e


  indexed: (id) ->
    if !@indexes[id]
      _.each @internals, (element, index) =>
        @indexes[id] = index if $(element).attr('href') is "/#{id}"
    @indexes[id]


  activate: ->
    path = document.location.pathname
    links = @internals.toArray().concat @internalish.toArray()
    current = _.find links, (link) ->
      $(link).attr('href') == path
    $(current).closest('li').addClass('active') if current


  discharge: ->
    @is_discharged = true
    @internalish.closest('li').removeClass 'active'

