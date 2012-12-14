#= require utensils/bindable
#= require components/namespace
#= require_tree ./routers
#= require_tree ./views

class modeset.ModeSet

  routers: [
    modeset.ApplicationRouter
  ]

  views: [
    modeset.NavigationView
    modeset.ContentView
    modeset.BackgroundView
    modeset.TitleView
  ]

  constructor: (@el, data) ->
    @initialize()


  initialize: ->
    new router(@, @views) for router in @routers
    Backbone.history.start(pushState: true, silent: true)


utensils.Bindable.register 'modeset', modeset.ModeSet

