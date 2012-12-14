class modeset.ApplicationRouter extends Backbone.Router

  routes:
    ''    : 'page'
    ':id' : 'page'

  constructor: (@app, @view_classes) ->
    super
    @initialize()
    @addListeners()


  initialize: ->
    @views = []
    @views.push(new view()) for view in @view_classes


  page: (route) ->
    route ?= 'index'
    _(@views).invoke 'render', route


  dispose: ->
    return unless @views.length
    @removeListeners()
    _(@views).invoke 'dispose'
    @views = []


  changed: (e) ->
    route = $(e.target).attr 'href'
    @navigate route, {trigger: true}


  addListeners: ->
    @views[0].on 'click:internal', => @changed arguments...


  removeListeners: ->
    @views[0].off 'click:internal'

