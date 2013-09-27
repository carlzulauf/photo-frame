#= require vendor/jquery-1.10.2
#= require_self
#= require_tree ./photo_frame

class PhotoFrame
  constructor: (images) ->
    @images = new PhotoFrame.Images(images)

window.PhotoFrame = PhotoFrame;

$ =>
  window.photos = new PhotoFrame(IMAGES)
