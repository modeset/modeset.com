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

