
bittheory.SectionView = Backbone.View.extend({
  el: $('#content'),


  initialize: function() {
    console.log(this.el)
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

