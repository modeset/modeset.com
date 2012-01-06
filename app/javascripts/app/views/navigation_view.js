
// ## Navigation View
// **File: views/navigation_view.js**

// Controls the hover, unhover and active states on the jib jabs

modeset.NavigationView = Backbone.View.extend({
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
    return this
  },

  dispose: function() {
  }

})

