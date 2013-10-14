class PhotoFrame.Images
  constructor: (@app) ->
    @images = []
    @prefix = "http://carl.linkleaf.com:9292"
    @path = "/fetch/"
    @app.$frame.append('<div class="images"></div>')
    @$images = @app.$frame.find(".images")
    @preloadTarget = 3
    @interval = 16000

  show: ->
    @loadNext()
    @startTimer()

  hide: ->
    @stopTimer()
    @$images.fadeOut()

  pause: ->
    @stopTimer()

  resume: ->
    @show()

  next: ->
    @loadNext()

  load: ->
    @loadImages()

  loadImages: ->
    $.getJSON @prefix + "/photos.json?callback=?", (data) =>
      images = data.photos
      @images.each (token) =>
        images.push token
      @images = images
      @preload()

  nextImage: ->
    @loadImages() if @images.length < 10
    @images.pop()

  preload: ->
    n = @preloadTarget - @$images.find(".image-container").length
    n.times =>
      @$images.append @createImg(@nextImage())

  loadNext: ->
    $last = @$images.find(".image-container.current").first()
    $next = @$images.find(".image-container:not(.current)").first()
    if $last.length > 0
      $last.fadeOut {
        duration: 500,
        complete: =>
          $last.remove()
          @showImg $next
      }
    else if $next.length > 0
      @showImg $next
    $next

  showImg: ($img) ->
    $img.fadeIn {duration: 300}
    $img.addClass("current")
    @preload()

  createImg: (info) ->
    w = $(window).width()
    h = $(window).height()
    $img = $( document.createElement('img') )
    $img.attr("src", @prefix + @path + info.token + "?width=" + w + "&height=" + h)
    $name = $( document.createElement('div') )
    $name.addClass "photo-name"
    $name.text info.path
    $container = $( document.createElement('div') )
    $container.addClass "image-container"
    $container.append $name, $img
    $container

  startTimer: ->
    @timer = window.setInterval (=> @loadNext() ), @interval

  stopTimer: ->
    window.clearInterval(@timer)

  loaded: ->
    $imgs = @$images.find("img")
    zeroes = $imgs.filter ->
      this.naturalHeight == 0
    $imgs.length > 0 and zeroes.length == 0
