require 'photo_frame/config'
require 'photo_frame/library'
require 'photo_frame/server'

class PhotoFrame
  def self.config
    yield Config.instance if block_given?
    Config.instance
  end

  def self.root
    config.root
  end
end
