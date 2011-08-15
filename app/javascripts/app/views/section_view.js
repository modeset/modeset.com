
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

