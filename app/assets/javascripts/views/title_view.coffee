class modeset.TitleView extends Backbone.View

  el: 'head title'

  constructor: ->
    super


  render: (route) ->
    route = if route is 'index' then 'home' else route.replace /\-/g, ' '
    @$el.text "Mode Set / #{@titleize route}"
    @


  titleize: (route) ->
    title = _.map route.split(/\W/g), (str) ->
      str.charAt(0).toUpperCase() + str.slice 1
    title.join().replace /,/g, ' '


  dispose: ->
    @undelegateEvents()

