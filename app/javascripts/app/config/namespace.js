
// ## Global Namespace and Utility functions
// **File: namespace.js**

// Applications primary namespace
var modeset = {
  VERSION: '0.1.0'
}

// ### Various Utility functions that probably should have a home
modeset.util = {

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

