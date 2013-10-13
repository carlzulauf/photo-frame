#= require_self
#= require_tree ./photo_frame

class PhotoFrame
  constructor: () ->
    @images = new PhotoFrame.Images()

window.PhotoFrame = PhotoFrame;

$ =>
  window.photos = new PhotoFrame()
  if window.enyo and window.enyo.setFullScreen
    enyo.setFullScreen(true);
    enyo.windows.setWindowProperties {blockScreenTimeout: true}
