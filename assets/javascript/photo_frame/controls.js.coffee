class PhotoFrame.Controls
  constructor: (@app) ->
    @showFor = 5000
    @showTo = 0
    @buildControls()
    @listen()

  buildControls: ($el) ->
    @$next = $( document.createElement("div") )
    @$next.html("<button>next</button>")
    @$next.addClass("next")

    @$prev = $( document.createElement("div") )
    @$prev.html("<button>prev</button>")
    @$prev.addClass("prev")

    @$pause = $( document.createElement("div") )
    @$pause.html("<button>pause</button>")
    @$pause.addClass("pause")

    @$resume = $( document.createElement("div") )
    @$resume.html("<button>resume</button>")
    @$resume.addClass("resume")

    @$controls = $( document.createElement("div") )
    @$controls.addClass("controls")
    @$controls.append @$next, @$prev, @$pause, @$resume

    @app.$frame.append @$controls

  listen: ($el) ->
    @app.$frame.click =>
      @show()
    @$next.click =>
      @app.images.next()
    @$prev.click =>
      @app.images.prev()
    @$pause.click =>
      @app.images.pause()
      @$pause.hide()
      @$resume.show()
    @$resume.click =>
      @app.images.resume()
      @$resume.hide()
      @$pause.show()

  show: ->
    @$controls.fadeIn()
    @app.$frame.find(".photo-name").fadeIn()
    @showTo = (new Date).getTime() + @showFor
    @fadeTimer()

  fadeTimer: ->
    time = (new Date).getTime()
    if time >= @showTo
      @$controls.fadeOut()
      @app.$frame.find(".photo-name").fadeOut()
    else
      window.setTimeout (=> @fadeTimer() ), @showTo - time
