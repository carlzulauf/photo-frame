class PhotoFrame.Images
  constructor: (@images) ->
    @path = "/fetch?file="
    @current = 0
    @$frame = $("#photo-frame")
    @loaded = []
    @preload(3)
    window.setTimeout (=> @loadNext(); @startTimer() ), 1000

  nextIdx: (from = @current) ->
    next = from + 1
    next = 0 if next >= @images.length
    next

  nextIdxs: (n = 1, from = @current) ->
    ids = []
    last = from
    n.times =>
      last = @nextIdx(last)
      ids.push last
    ids

  next: ->
    idx = @nextIdx()
    @current = idx
    @images[idx]

  preload: (n = 1) ->
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
    else
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
    @preload 1

  createImg: (file) ->
    $img = $( document.createElement('img') )
    $img.attr("src", @path + file)
    $img

  startTimer: ->
    @timer = window.setInterval (=> @loadNext() ), 16000
