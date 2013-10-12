class PhotoFrame.Images
  constructor: () ->
    @images = []
    @prefix = "http://carl.linkleaf.com:9292"
    @path = "/fetch/"
    @$frame = $("#photo-frame")
    @preloadTarget = 3
    @loadImages()
    @$frame.click =>
      @click()
    window.setTimeout (=> @loadNext(); @startTimer() ), 1000

  click: ->
    @stopTimer()
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

  showImg: ($img) ->
    w = $(window).width()
    h = $(window).height()
    ar = w / h # window aspect ratio
    iw = $img.width()
    ih = $img.height()
    iar = iw / ih # image aspect ratio
    if iar > ar
      top = Math.round( (h - ( w / iar )) / 2 )
      $img.width w
      $img.css {"margin-top": top + "px"}
    else
      left = Math.round( (w - ( h * iar )) / 2 )
      $img.height h
      $img.css {"margin-left": left + "px"}
    $img.fadeIn {
      duration: 300
    }
    $img.addClass("current")
    @preload()

  createImg: (info) ->
    $img = $( document.createElement('img') )
    $img.attr("src", @prefix + @path + info.token)
    $img

  startTimer: ->
    @timer = window.setInterval (=> @loadNext() ), 16000

  stopTimer: ->
    window.clearInterval(@timer)
