
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

