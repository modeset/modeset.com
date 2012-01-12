
// ## DocumentView
// **File: views/document_view.js**

// The view for the primary router

modeset.DocumentView = Backbone.View.extend({
  el: $('body'),
  tt: $('head title'),

  events: {
    'click a.internal': 'click',
  },


  initialize: function() {
    _.bindAll(this, 'render')
    this.addListeners()
    this.buildLogo()
  },

  addListeners: function() {
  },
  
  isCanvasSupported: function() {
		var elem = document.createElement('canvas');
		return !!(elem.getContext && elem.getContext('2d'));
  },

  buildLogo: function() {
		if( this.isCanvasSupported() ) { 
			var logo = new Logo( $('header#header nav')[0], 43 );
		}
  },

  click: function(e) {
    e.preventDefault()
    this.trigger("internal:click", e)
  },

  render: function(route) {
    var path = (route === 'index') ? 'home' : route
    var title = path.charAt(0).toUpperCase() + path.slice(1)
    this.el.attr('id', path)
    this.tt.text('Mode Set / ' + title)
    return this
  },

  removeListeners: function() {
  },

  dispose: function() {
    this.removeListeners()
  }

})

