class Logo3d

  constructor: (@container404) ->
    @buildSceneAndCamera()
    @buildLogo()
    @buildLights()
    @buildShadowLight()
    @active = true
    @animate()
    window.addEventListener 'resize', @resize
    window.addEventListener 'mousemove', @pointermoved
    window.addEventListener 'touchmove', @pointermoved


  setActive: (@active, @container404) ->
    if @active == true
      @container404.appendChild @containerTHREE
      @animate()
    else
      @containerTHREE.parentNode.removeChild(@containerTHREE)


  lerp: (val1, val2, percent) ->
    return val1 + (val2 - val1) * percent


  clamp: (val, min, max) ->
    return Math.max(min, Math.min(max, val))


  pointermoved: =>
    @pointerMoved = true


  resize: =>
    @camera.aspect = @container404.offsetWidth / @container404.offsetHeight
    @camera.updateProjectionMatrix()
    @renderer.setSize @container404.offsetWidth, @container404.offsetHeight


  buildSceneAndCamera: ->
    @SCREEN_WIDTH = @container404.offsetWidth
    @SCREEN_HEIGHT = @container404.offsetHeight
    @VIEW_ANGLE = 45
    @ASPECT = @SCREEN_WIDTH / @SCREEN_HEIGHT
    @NEAR = 0.1
    @FAR = 20000
    @scene = new (THREE.Scene)
    @camera = new (THREE.PerspectiveCamera)(@VIEW_ANGLE, @ASPECT, @NEAR, @FAR)
    @scene.add @camera
    @camera.position.set 0, 0, 400
    @camera.lookAt @scene.position

    @renderer = new (THREE.WebGLRenderer)(antialias: true)
    @renderer.setClearColor 0xffffff
    @renderer.setSize @SCREEN_WIDTH, @SCREEN_HEIGHT
    @renderer.shadowMap.enabled = true
    @renderer.shadowMap.type = THREE.PCFSoftShadowMap

    @containerTHREE = document.createElement('div')
    @container404.appendChild @containerTHREE
    @containerTHREE.appendChild @renderer.domElement


  buildLogo: ->
    modeSetPoints = []
    modeSetPoints.push(new THREE.Vector2(176, 77))
    modeSetPoints.push(new THREE.Vector2(176, -81))
    modeSetPoints.push(new THREE.Vector2(132, -145))
    modeSetPoints.push(new THREE.Vector2(132, -72))
    modeSetPoints.push(new THREE.Vector2(32, -216))
    modeSetPoints.push(new THREE.Vector2(32, -113))
    modeSetPoints.push(new THREE.Vector2(4, -79))
    modeSetPoints.push(new THREE.Vector2(4, -237))
    modeSetPoints.push(new THREE.Vector2(-97, -141))
    modeSetPoints.push(new THREE.Vector2(-97, -61))
    modeSetPoints.push(new THREE.Vector2(-119, -41))
    modeSetPoints.push(new THREE.Vector2(-119, -84))
    modeSetPoints.push(new THREE.Vector2(-174, -34))
    modeSetPoints.push(new THREE.Vector2(-174, 239))
    modeSetPoints.push(new THREE.Vector2(-119, 186))
    modeSetPoints.push(new THREE.Vector2(-119, 108))
    modeSetPoints.push(new THREE.Vector2(-97, 87))
    modeSetPoints.push(new THREE.Vector2(-97, 131))
    modeSetPoints.push(new THREE.Vector2(-45, 82))
    modeSetPoints.push(new THREE.Vector2(49, 218))
    modeSetPoints.push(new THREE.Vector2(49, 82))
    modeSetPoints.push(new THREE.Vector2(147, 224))
    modeSetPoints.push(new THREE.Vector2(147, 109))

    modeSetShape = new (THREE.Shape)(modeSetPoints)
    extrusionSettings =
      amount: 80
      bevelEnabled: false
      material: 0
      extrudeMaterial: 1
    modeSetLogoGeometry = new (THREE.ExtrudeGeometry)(modeSetShape, extrusionSettings)
    THREEx.GeometryUtils.center modeSetLogoGeometry, true, true, true

    # add a wireframe to model
    materialFront = new (THREE.MeshPhongMaterial)(
      color: 0x00bce4
      emissive: 0x000000
      specular: 0x111111
      shininess: 20
      shading: THREE.SmoothShading
      wireframe: false)

    materialSide = new (THREE.MeshLambertMaterial)(
      color: 0xffffff
      emissive: 0x888888)
    materialArray = [
      materialFront
      materialSide
    ]

    @modeSetSolid = new (THREE.Mesh)(modeSetLogoGeometry, new (THREE.MeshFaceMaterial)(materialArray))
    @modeSetSolid.position.set 0, 0, -1000
    @modeSetSolid.rotation.x = -0.2
    @modeSetSolid.rotation.y = Math.PI
    @modeSetSolid.castShadow = true
    @modeSetSolid.scale.set(0.001, 0.001 ,0.001)
    @scene.add @modeSetSolid


  buildLights: ->
    ambientLight = new (THREE.AmbientLight)(0x000000)
    @scene.add ambientLight

    pointLight = new (THREE.PointLight)(0xffffff, 1, 0)
    pointLight.position.set 100, 300, 0
    @scene.add pointLight


  buildShadowLight: ->
    spotlight = new (THREE.SpotLight)(0xffffff)
    spotlight.position.set 0, 3000, -800
    spotlight.target = @modeSetSolid
    spotlight.castShadow = true
    spotlight.shadowDarkness = 0.15
    # spotlight.shadowCameraVisible	= false; // .shadowCameraVisible has been removed. Use new THREE.CameraHelper( light.shadow ) instead.
    spotlight.shadowBias = 0.0001
    spotlight.shadowMapWidth = 2048
    spotlight.shadowMapHeight = 2048
    @scene.add spotlight
    window.spotlight = spotlight

    # add plane floor
    geometry = new (THREE.PlaneBufferGeometry)(2000, 2000)
    material = new (THREE.MeshBasicMaterial)(
      color: 0xffffff
      side: THREE.DoubleSide)
    plane = new (THREE.Mesh)(geometry, material)
    plane.rotation.x = Math.PI / 2
    plane.position.set 0, -360, -1000
    plane.receiveShadow = true
    @scene.add plane


  animate: =>
    requestAnimationFrame @animate if @active == true
    @renderer.render @scene, @camera
    pointerX = @clamp(window.pointerPos.yPercent(@container404), -0.2, 1.2)
    pointerY = @clamp(window.pointerPos.xPercent(@container404), -0.2, 1.2)
    if !@pointerMoved
      pointerX = pointerY = 0.5
    newX = 2 * (pointerX - 0.5)
    newY = Math.PI + 2 * (pointerY - 0.5)
    @modeSetSolid.rotation.x = @lerp(@modeSetSolid.rotation.x, newX, 0.2)
    @modeSetSolid.rotation.y = @lerp(@modeSetSolid.rotation.y, newY, 0.2)

    newScale = @lerp(@modeSetSolid.scale.x, 1, 0.2)
    @modeSetSolid.scale.set(newScale, newScale, newScale)


window.Logo3d = Logo3d
