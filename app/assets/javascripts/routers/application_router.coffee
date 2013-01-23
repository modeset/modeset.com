class modeset.ApplicationRouter extends Backbone.Router

  routes:
    ''    : 'page'
    ':id' : 'page'

  constructor: (@app, @view_classes) ->
    super
    @init()
    @addListeners()


  init: ->
    @views = []
    @views.push(new view()) for view in @view_classes


  page: (route) ->
    route ?= 'index'
    _gaq.push(['_trackPageview', route])
    _.invoke @views, 'render', route


  dispose: ->
    return unless @views.length
    @removeListeners()
    _.invoke @views, 'dispose'
    @views = []


  changed: (e) ->
    route = $(e.target).attr 'href'
    @navigate route, {trigger: true}
    window.scrollTo 0, 0


  addListeners: ->
    @views[0].on 'click:internal', => @changed arguments...


  removeListeners: ->
    @views[0].off 'click:internal'

