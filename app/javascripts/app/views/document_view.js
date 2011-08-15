
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

