class modeset.NavigationView extends Backbone.View

  el: 'body'

  events:
    "click .internal": 'clicked'

  constructor: ->
    super
    @indexes = {}
    @internals = @$el.find '.internal'
    @listings = @internals.parent 'li'


  render: (route) ->
    @listings.removeClass 'active'
    @listings.eq(@indexed(route)).addClass 'active'
    return this


  dispose: ->
    @undelegateEvents()


  clicked: (e) ->
    e.preventDefault()
    @trigger 'click:internal', e


  indexed: (id) ->
    if !@indexes[id]
      _(@internals).each (element, index) =>
        @indexes[id] = index if $(element).attr('href') is "/#{id}"
    @indexes[id]

