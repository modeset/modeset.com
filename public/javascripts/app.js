
// ## Global Namespace and Utility functions
// **File: namespace.js**

// Applications primary namespace
var bittheory = {
  VERSION: '0.0.1'
}

// ### Various Utility functions that probably should have a home
bittheory.util = {

  // map each template to their id's
  mapTemplates: function(el) {
    var node = $(el)
    var kids = node.children()
    var templates = {}

    // store the id (key) and converted template (value)
    _.each(kids, function(kid) {
      templates[kid.id] = $(kid).html()
    })

    // blow it out of the html
    node.remove()
    return templates
  }

}


// ## Header
// **File: views/header_view.js**

// This is the main container shell for the header

bittheory.HeaderView = Backbone.View.extend({
  el: $('#header'),

  events: {
    'click a': 'linker',
  },


  initialize: function() {
    // _.bindAll(this, 'render', 'build')
    // this.template = this.options.template
    // this.build()
    // this.render()
    // this.addListeners()
  },

  addListeners: function() {
    // this.model.bind('change:slide', this.render)
  },

  linker: function(e) {
    e.preventDefault()
    this.trigger("navigate:click", e)
  },

  build: function() {
    // var data = this.model.toJSON()
    // this.el.html(this.template(data))
  },

  render: function() {
    // var data = this.model.toJSON()
    // return this
  },

  removeListeners: function() {
    // this.model.unbind('change', this.render)
  },

  dispose: function() {
    this.removeListeners()
  }

})


bittheory.SectionView = Backbone.View.extend({
  el: $('#content'),


  initialize: function() {
  },

  render: function(content) {
    this.el.html(content)
    // var data = this.model.toJSON()
    // return this
  },

  dispose: function() {
    // this.removeListeners()
  }

})

// ## Context Router
// **File: router.js**

// Main Application startup and central dispatch

bittheory.Router = Backbone.Router.extend({

  routes: {
    '': 'index',
    ':id': 'area',
  },

  initialize: function() {
    _.bindAll(this, 'startup', 'addListeners', 'navigator')
    this.startup()
    // var loader = new exhibit.JsonService(data_url, this.startup)
  },

  startup: function(response) {
    // var data = response
    this.templates = bittheory.util.mapTemplates('#templates')

    this.header_view = new bittheory.HeaderView({model: null, template: null})
    this.section_view = new bittheory.SectionView({model: null, template: null})

    this.addListeners()
    // console.log(this.templates)
  },

  index: function(route) {
    var path = route || 'index'
    this.render(path)
  },

  area: function(route) {
    this.render(route)
  },

  render: function(route) {
    var tmpl = route + '_template'
    this.section_view.render(this.templates[tmpl])
  },

  navigator: function(e) {
    this.navigate(e.target.pathname.substr(1), true)
  },

  addListeners: function() {
    this.header_view.bind('navigate:click', this.navigator)
  },

  removeListeners: function() {
  },

  dispose: function() {
    this.removeListeners()
  }

})


$(document).ready(function() {
  bittheory.app = new bittheory.Router()
  Backbone.history.start({pushState: true, silent: true})
})

