class ViewCommon

  mediaServices = [
    window.embetter.services.youtube,
    window.embetter.services.vimeo,
    window.embetter.services.codepen
  ]

  constructor: (el, isInitialLoad) ->
    @el = el
    @initScrollables()
    window.embetter.utils.initMediaPlayers(@el, mediaServices)
    @initMap()

  loadRemoteScript: (scriptURL) ->
    tag = document.createElement('script')
    tag.src = scriptURL
    firstScriptTag = document.getElementsByTagName('script')[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag
    return


  initMap: ->
    if window.google
      @initMapCallback()
    else
      window.initMap = @initMapCallback
      @loadRemoteScript('https://maps.googleapis.com/maps/api/js?callback=initMap')


  initMapCallback: =>
    if mapEl = document.getElementById('map')
      # build map
      map = new google.maps.Map(mapEl,
        scrollwheel: false
        mapTypeControl: false
        styles: [{"stylers":[{"hue":"#00aaff"},{"saturation":-50},{"gamma":1.1},{"lightness":5}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"lightness":24}]}]
        center:
          lat: 39.755145
          lng: -105.0045
        zoom: 18)
      # add instruction arrows
      line = @buildPolyLine(map, [{lat: 39.755443, lng: -105.004423}, {lat: 39.755225, lng: -105.004107}])
      line = @buildPolyLine(map, [{lat: 39.754854, lng: -105.004370}, {lat: 39.755105, lng: -105.004075}])

      # add mode set logo marker
      image = 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="29.336" height="40" viewBox="0 0 29.336 40"><path fill="#02BDE4" d="M24.633 4.485v6.477l-1.737 1.706v-3.709l-4.424 4.164-7.893-11.509v11.46l-8.218-11.984v9.864l-2.361 2.665v13.177l3.74 5.521v-6.231l8.394 12.177v-8.795l2.211-2.789v13.321l8.551-8.119v-6.734l1.737-1.613v3.66l4.703-4.319v-22.875z"/></svg>'
      marker = new google.maps.Marker(
        position:
          lat: 39.755145
          lng: -105.0040
        map: map
        animation: google.maps.Animation.DROP
        icon: image
      )


  buildPolyLine: (map, pathObj) ->
    lineSymbol =
      path: google.maps.SymbolPath.FORWARD_OPEN_ARROW
    return new google.maps.Polyline(
      path: pathObj
      icons: [{icon: lineSymbol, offset: '100%'}]
      map: map
      strokeOpacity: 0.9
      strokeWeight: 1.5
      strokeColor: '#444'
    )


  initScrollables: ->
    scrollEls = @el.querySelectorAll('.scrollable')
    # @scrollables = []
    # for(i=0 i < scrollEls.length i++) {
    #   @scrollables.push(new Scrollable(scrollEls[i]))


  dispose: ->
    window.embetter.utils.disposePlayers()
    # for scrollable in @scrollables
    #   scrollable.dispose()
    # @scrollables.splice(0)

window.ViewCommon = ViewCommon
