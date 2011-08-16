
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

