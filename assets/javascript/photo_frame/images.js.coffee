class PhotoFrame.Images
  constructor: () ->
    @images = []
    @prefix = "http://carl.linkleaf.com:9292"
    @path = "/fetch/"
    @$frame = $("#photo-frame")
    @$name = $("#photo-name")
    @preloadTarget = 3
    @showName = false
    @loadImages()
    @$frame.click =>
      @click()
    window.setTimeout (=> @loadNext(); @startTimer() ), 1000

  click: ->
    @stopTimer()
    @showName = true
    @loadNext()
    @startTimer()

  loadImages: ->
    $.getJSON @prefix + "/photos.json?callback=?", (data) =>
      images = data.photos
      @images.each (token) =>
        images.push token
      @images = images
      @preload()

  next: ->
    @loadImages() if @images.length < 10
    @images.pop()

  preload: ->
    n = @preloadTarget - @$frame.find("img").length
    n.times =>
      @$frame.append @createImg(@next())

  loadNext: ->
    $last = @$frame.find("img.current").first()
    $next = @$frame.find("img:not(.current)").first()
    if $last.length > 0
      $last.fadeOut {
        duration: 500,
        complete: =>
          @showImg $next
          $last.remove()
      }
    else if $next.length > 0
      @showImg $next
    $next

  showImg: ($img) ->
    $img.fadeIn {
      duration: 300
    }
    if @showName
      @$name.fadeIn {duration: 300}
      @showName = false
    else
      @$name.hide()
    $img.addClass("current")
    @preload()

  createImg: (info) ->
    w = $(window).width()
    h = $(window).height()
    $img = $( document.createElement('img') )
    $img.attr("src", @prefix + @path + info.token + "?width=" + w + "&height=" + h)
    @$name.text info.path
    $img

  startTimer: ->
    @timer = window.setInterval (=> @loadNext() ), 16000

  stopTimer: ->
    window.clearInterval(@timer)
