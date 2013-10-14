#= require_self
#= require_tree ./photo_frame

class PhotoFrame
  constructor: () ->
    @$frame = $("#photo-frame")
    @images = new PhotoFrame.Images(this)
    @loader = new PhotoFrame.Loader(this)
    @loader.show()
    @images.load()
    @checkImages()

  checkImages: ->
    if @images.loaded()
      @loader.hide()
      @images.show()
    else
      window.setTimeout (=> @checkImages() ), 500

window.PhotoFrame = PhotoFrame;
