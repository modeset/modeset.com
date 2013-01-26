class modeset.BackgroundView extends Backbone.View

  el: 'body'

  constructor: ->
    super


  render: (route) ->
    @$el.attr 'class', "body-#{route}"
    @


  dispose: ->
    @undelegateEvents()

