class Main

  constructor: ->
    @debugOutput()
    @initMinivents()
    @listenForScroll()
    requestAnimationFrame =>
      @areaModel = new AreaModel(document.getElementById('content'))
      # scrollEase(1000, -500)


  closeMobileMenu: ->
    document.getElementById('menu-toggle').checked = false


  debugOutput: ->
    browsers = /chrome|firefox/i
    if browsers.test(navigator.userAgent.toLowerCase())
      console.log("%c MODE SET ", ["background: #00bce4", "color: white"].join(";"))


  initMinivents: ->
    @events = new Events()


  listenForScroll: ->
    window.addEventListener 'scroll', @onScroll
    # debugging for now
    @scrollDebug = document.querySelector('#scroll-current')
    @events.on "scroll", (data) =>
      # @scrollDebug.innerHTML = 'scroll: ' + data.scrollY


  onScroll: =>
    @events.emit("scroll", {scrollY: window.scrollY})

window.Main = Main
