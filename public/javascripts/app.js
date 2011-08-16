
// ## Global Namespace and Utility functions
// **File: namespace.js**

// Applications primary namespace
var bittheory = {
  VERSION: '0.1.0'
}

// ### Various Utility functions that probably should have a home
bittheory.util = {

  // map each template to their id's
  mapTemplates: function(el) {
    var node = $(el)
    var kids = node.children()
    var templates = {}

    // store the id (key) and html string (value)
    _.each(kids, function(kid) {
      templates[kid.id] = $(kid).html()
    })

    // blow it out of the html
    node.remove()
    return templates
  }

}


// ## DocumentView
// **File: views/document_view.js**

// The view for the primary router

bittheory.DocumentView = Backbone.View.extend({
  el: $('body'),
  tt: $('head title'),

  events: {
    'click a.internal': 'click',
  },


  initialize: function() {
    _.bindAll(this, 'render')
    this.addListeners()
  },

  addListeners: function() {
  },

  click: function(e) {
    e.preventDefault()
    this.trigger("internal:click", e)
  },

  render: function(route) {
    var path = (route === 'index') ? 'home' : route
    var title = path.charAt(0).toUpperCase() + path.slice(1)
    this.el.attr('id', path)
    this.tt.text('Bit Theory / ' + title)
    return this
  },

  removeListeners: function() {
  },

  dispose: function() {
    this.removeListeners()
  }

})


// ## Navigation View
// **File: views/navigation_view.js**

// Controls the hover, unhover and active states on the jib jabs

bittheory.NavigationView = Backbone.View.extend({
  el: $('#header'),
  jibs: $('.jib-jab', this.el),

  events: {
    'mouseover a': 'hover',
    'mouseout a': 'unhover',
  },

  initialize: function() {
  },

  getJib: function(target) {
    return $(target).siblings('.jib-jab').first()
  },

  hover: function(e) {
    var jib = this.getJib(e.target)
    jib.addClass('over')
    return this
  },

  unhover: function(e) {
    var jib = this.getJib(e.target)
    jib.removeClass('over')
    return this
  },

  render: function(route) {
    this.jibs.removeClass('active')
    var link = this.el.find('.' + route)[0]

    if (link) {
      this.getJib(link).addClass('active')
    }
    return this
  },

  dispose: function() {
  }

})


bittheory.SectionView = Backbone.View.extend({
  el: $('#content'),

  initialize: function() {
  },

  render: function(content) {
    this.el.html(content)
    return this
  },

  dispose: function() {
  }

})


// ## Main Router
// **File: router.js**

// Main Application startup and central dispatch

bittheory.Router = Backbone.Router.extend({

  routes: {
    '': 'index',
    ':id': 'section',
  },

  initialize: function() {
    _.bindAll(this, 'startup', 'addListeners', 'update')
    this.startup()
  },

  startup: function() {
    this.templates = bittheory.util.mapTemplates('#templates')
    this.document_view = new bittheory.DocumentView()
    this.navigation_view = new bittheory.NavigationView()
    this.section_view = new bittheory.SectionView()

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
    this.navigation_view.render(route)
    this.section_view.render(this.templates[tmpl])
  },

  update: function(e) {
    this.navigate(e.target.pathname.substr(1), true)
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
  bittheory.app = new bittheory.Router()
  Backbone.history.start({pushState: true})
})

