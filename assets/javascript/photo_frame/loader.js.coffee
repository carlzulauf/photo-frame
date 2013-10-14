class PhotoFrame.Loader
  constructor: (@app) ->
    @glowInterval = 1000
    @app.$frame.append('<div class="loader">Loading...</div>');
    @$loader = @app.$frame.find(".loader")
    @showing = false;
    @out = true;

  show: ->
    @showing = true;
    @$loader.fadeIn();
    @glow();

  hide: ->
    @showing = false;
    @$loader.hide()

  glow: ->
    if @showing
      css = @css()
      # console.log("Animating to " + JSON.stringify(css))
      @$loader.animate css, {
        duration: @glowInterval,
        complete: (=> @glow() )
      }

  css: ->
    if @out
      @out = false;
      {opacity: 0.9}
    else
      @out = true;
      {opacity: 0.1};
