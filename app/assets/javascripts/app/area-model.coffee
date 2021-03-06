class AreaModel
  constructor: (contentEl) ->
    @contentEl = contentEl
    @pageTitle = document.title.split(' | ')[0]
    @curPath = null
    @queuedPath = null
    @curAreaObj = null
    @isTransitioning = false
    @initFirstSection()
    @initRoutes()


  index: =>
    if !@isTransitioning
      @curPath = page.current
      # exit section if path changed
      if @curPath != @prevPath
        document.body.classList.remove(@pathToClass(@prevPath)) if @prevPath.length > 1
        document.body.classList.add(@pathToClass(@curPath)) if @curPath.length > 1 # protect against '/' path
        easyScroll.scrollByY(600, easyScroll.scrollY()) if easyScroll.scrollY() > 20
        @exitCurSection()
        document.title = @formatDocumentTitle()
    else
      @queuedPath = page.current


  initRoutes: ->
    page('', @index)
    page('/', @index)
    page('/:id', @index)
    # page('/news/:id', index)
    # page('*', notfound)
    page()


  initFirstSection: ->
    # initialize section that loaded with the page and track our initial path
    @prevPath = document.location.href.replace(document.location.origin,'')
    @createMainContentObj(@contentEl.children[0], false)


  exitCurSection: ->
    @isTransitioning = true
    if @contentEl.children.length > 0
      @contentEl.classList.add('hiding')
      setTimeout =>
        @contentHidden()
      , 300
    else
      @contentHidden()


  contentHidden: ->
    # dispose previous area object
    @curAreaObj?.dispose()
    @curAreaObj = null
    # load new area, since all previous are cleared out now
    @loadAjaxContent( @curPath )


  loadAjaxContent: (path) ->
    # strip tail slash if there is one
    if path.length > 1 && path[ path.length - 1 ] == '/'
      path = path.substr( 0, path.length - 1 )
    # get area html path based on section
    window.reqwest
      url: path,
      success: (data) =>
        @createMainContentObj(data, true)
        @showAjaxContent()


  createMainContentObj: (data, replaceContent) ->
    # read area type from data attribute of first element
    newContentEl
    if typeof data == "string"
      newContentEl = @stringToDomElement(data)  # transform from string
    else
      newContentEl = data  # read initial page html from dom

    pageType = newContentEl.getAttribute('data-area-type')
    @contentEl.innerHTML = data if(replaceContent == true)

    # create area object if there is one
    isInitialLoad = !replaceContent
    @curAreaObj = new ViewCommon( @contentEl, isInitialLoad )


  showAjaxContent: ->
    # fade it in
    @contentEl.classList.remove('hiding')
    # window.scrollTo(0,0)
    # store previous paths, set flags
    @prevPath = @curPath
    @isTransitioning = false
    # check to see if the path has changed during destroy/rebuild
    if @queuedPath
      @queuedPath = null
      @index()
    # track it
    setTimeout =>
      ga 'send',
        hitType: 'pageview'
        page: location.pathname
    , 200


  stringToDomElement: (str) ->
    div = document.createElement('div')
    div.innerHTML = str
    return div.children[0]


  formatDocumentTitle: ->
    titleParts = @curPath.split('/')
    i = 0
    while i < titleParts.length
      subParts = titleParts[i].split('-')
      j = 0
      while j < subParts.length
        subParts[j] = @toTitleCase(subParts[j])
        j++
      titleParts[i] = subParts.join(' ')
      i++
    if( @curPath != '/' )
      return @pageTitle + ' ' + titleParts.join(' | ')
    else
      return @pageTitle


  toTitleCase: (str) ->
    return str.substr(0,1).toUpperCase() + str.substr(1).toLowerCase()


  pathToClass: (path) ->
    path = path.substr(1) if path.indexOf('/') == 0
    return path


window.AreaModel = AreaModel
