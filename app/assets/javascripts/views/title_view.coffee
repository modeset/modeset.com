class modeset.TitleView extends Backbone.View

  el: 'head title'

  constructor: ->
    super


  render: (route) ->
    route = if route is 'index' then 'home' else route
    title = route.charAt(0).toUpperCase() + route.slice(1)
    @$el.text "Mode Set / #{title}"
    @


  dispose: ->
    @undelegateEvents()

