class Main

  constructor: ->
    @debugOutput()
    @addRemoteScriptLoading()
    @enableActivePseudoStyles()
    @addReadyClass()
    @initLogo()
    requestAnimationFrame =>
      @areaModel = new AreaModel(document.getElementById('content'))
      # easyScroll.scrollByY(1000, -500)


  addRemoteScriptLoading: ->
    window.loadRemoteScript = (scriptURL) ->
      tag = document.createElement('script')
      tag.src = scriptURL
      firstScriptTag = document.getElementsByTagName('script')[0]
      firstScriptTag.parentNode.insertBefore tag, firstScriptTag
      return

  enableActivePseudoStyles: ->
    @setTouchStyle = false
    document.addEventListener 'touchstart', ->
      if !@setTouchStyle
        document.body.classList.remove('no-touch')
        @setTouchStyle = true
      return # add empty touchstart listener to activate :active pseudo styles on touch


  addReadyClass: ->
    document.body.classList.add('ready')


  initLogo: ->
    logoEl = document.getElementById('logo-crest')
    @logo = new Logo(logoEl, 50 * 2)


  debugOutput: ->
    browsers = /chrome|firefox/i
    if browsers.test(navigator.userAgent.toLowerCase())
      console.log("%c MODE SET ", ["background: #00bce4", "color: white"].join(";"))


window.Main = Main
