class modeset.ContentView extends Backbone.View

  el: '#content'

  constructor: ->
    super
    @templates = {}


  render: (route) ->
    tmpl = @template route
    @$el.html tmpl
    return this


  dispose: ->
    @undelegateEvents()


  template: (id) ->
    @tmpl_el ?= $('#templates')
    if !@templates[id]
      @templates[id] = @tmpl_el.find("##{id}_template").html()
    @templates[id]

