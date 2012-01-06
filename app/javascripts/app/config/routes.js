
// ## Main Router
// **File: router.js**

// Main Application startup and central dispatch

modeset.Router = Backbone.Router.extend({

  routes: {
    '': 'index',
    ':id': 'section',
  },

  initialize: function() {
    _.bindAll(this, 'startup', 'addListeners', 'update')
    this.startup()
  },

  startup: function() {
    this.templates = modeset.util.mapTemplates('#templates')
    this.document_view = new modeset.DocumentView()
    this.navigation_view = new modeset.NavigationView()
    this.section_view = new modeset.SectionView()

    this.addListeners()
  },

  index: function(route) {
    var path = route || 'index'
    this.render(path)
  },

  section: function(route) {
    this.render(route)
  },

  render: function(route) {
    var tmpl = route + '_template'
    this.document_view.render(route)
    this.section_view.render(this.templates[tmpl])
    _gaq.push(['_trackPageview', route])
  },

  update: function(e) {
    var href = $(e.currentTarget).attr('href')
    this.navigate(href.substr(1), true)
  },

  addListeners: function() {
    this.document_view.bind('internal:click', this.update)
  },

  removeListeners: function() {
    this.document_view.unbind('internal:click', this.update)
  },

  dispose: function() {
    this.removeListeners()
  }

})


// ## Melt faces
$(document).ready(function() {
  modeset.app = new modeset.Router()
  Backbone.history.start({pushState: true, silent: true})
  setTimeout(function() {
    window.scrollTo(0, 1)
  }, 500);
})

