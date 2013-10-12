#= require_self
#= require_tree ./photo_frame

class PhotoFrame
  constructor: () ->
    @images = new PhotoFrame.Images()

window.PhotoFrame = PhotoFrame;

$ =>
  window.photos = new PhotoFrame()
  if enyo and enyo.setFullScreen
    enyo.setFullScreen(true);
