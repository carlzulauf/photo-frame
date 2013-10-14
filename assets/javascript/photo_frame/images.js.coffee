class PhotoFrame.Images
  constructor: (@app) ->
    @images = []
    @history = []
    @current = []
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
    @stopTimer()
    @loadNext()
    @startTimer()

  prev: ->
    if @history.length > 0
      @stopTimer()
      prev = @history.pop()
      $prev = @createImg(prev)
      @$images.prepend $prev
      $cur = @$images.find(".image-container.current").first()
      $cur.removeClass("current")
      $cur.fadeOut {
        duration: 500,
        complete: =>
          @current.unshift prev
          @showImg $prev
          @startTimer()
      }

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
      data = @nextImage()
      @current.push data
      @$images.append @createImg(data)

  loadNext: ->
    $last = @$images.find(".image-container.current").first()
    $next = @$images.find(".image-container:not(.current)").first()
    if $last.length > 0
      $last.fadeOut {
        duration: 500,
        complete: =>
          @addHistory @current.shift()
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

  addHistory: (info) ->
    @history.push info
    while @history.length > 100
      @history.shift()
