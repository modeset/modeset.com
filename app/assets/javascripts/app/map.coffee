class window.Map

  constructor: ->
    if window.google
      @initMapCallback()
    else
      window.initMap = @initMapCallback
      window.loadRemoteScript('https://maps.googleapis.com/maps/api/js?callback=initMap&key=AIzaSyCC9rSCkSgnYanfhNDoCyApmWVt-v0pOr8')


  initMapCallback: =>
    if mapEl = document.getElementById('map')
      mapCenter = {lat: 39.755118974126475, lng: -105.00417932868004}
      mapCenter = {lat: 39.75513753249523, lng: -105.00417840667069} if window.innerWidth < 600
      mapZoom = 19
      mapZoom = 18 if window.innerWidth < 390

      # build map
      map = new google.maps.Map(mapEl,
        scrollwheel: false
        mapTypeControl: false
        styles: [{"stylers":[{"hue":"#00aaff"},{"saturation":-50},{"gamma":1.1},{"lightness":5}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"lightness":24}]}]
        center: mapCenter
        zoom: mapZoom)

      # debug map lat/lng on click
      google.maps.event.addListener(map, "click", ((e) -> console.log(e.latLng.lat(), e.latLng.lng())))

      # add instruction arrows
      line = @buildPolyLine(map, [{lat: 39.75546952024727, lng: -105.00441268086433}, {lat: 39.75516640105893, lng: -105.00399}])
      line = @buildPolyLine(map, [{lat: 39.754854, lng: -105.004370}, {lat: 39.755105, lng: -105.004075}, {lat: 39.755105, lng: -105.004075}, {lat: 39.755095776158484, lng: -105.00399358570576}])

      # add mode set logo marker
      # image = 'data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="31.536" height="45.13" viewBox="0 0 31.536 45.13"><path fill="#09BEE4" d="M14.895 30.827l-1.111 1.401v10.37l-8.394-12.176v6.257l-4.84-7.145v-13.554l2.361-2.665v-11.431l8.218 11.985v-11.461l8.534 12.444 4.883-4.597v3.67l.637-.625v-6.481l5.803-5.535v24.401l-5.803 5.33v-3.65l-.637.591v6.73l-9.651 9.163z"/><path fill="#fff" d="M30.436 2.569v22.875l-4.703 4.319v-3.66l-1.737 1.613v6.734l-8.551 8.119v-13.321l-2.211 2.789v8.795l-8.394-12.177v6.231l-3.74-5.521v-13.177l2.361-2.665v-9.864l8.218 11.984v-11.46l7.893 11.509 4.424-4.164v3.709l1.737-1.706v-6.477l4.703-4.485m1.1-2.569l-1.859 1.773-4.703 4.485-.341.325v2.835l-1.391 1.309-3.489 3.284-7.167-10.45-2.007-2.927v11.459999999999999l-6.211-9.057-2.007-2.927v12.995999999999999l-2.084 2.353-.277.312v13.931l.189.279 3.74 5.521 2.011 2.968v-6.282l6.388 9.267 2.006 2.91v-11.945l.011-.014v12.724l1.857-1.764 8.551-8.119.343-.325v-3.081l1.381-1.268 4.703-4.319.356-.327v-25.927z"/></svg>'
      image = '/assets/mode-set-stroked.svg'
      marker = new google.maps.Marker(
        position:
          lat: 39.75505
          lng: -105.00392
        map: map
        animation: google.maps.Animation.DROP
        icon: image
      )


  buildPolyLine: (map, pathObj, hasArrow=true) ->
    if hasArrow
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
