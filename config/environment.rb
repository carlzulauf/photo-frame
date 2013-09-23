$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require 'json'
require 'encryptor'
require 'photo_frame'
require 'pry'

PhotoFrame.config do |config|
  config.paths << "/Users/carl/Pictures/test/**/*"
  config.patterns << ( /\.(jpe?g|png)/i )
  config.secret = "f1c693e4ac47ed5c4cbcb9a3a0c015fd659502b93ca26f35dae49fec6ed82589"
  config.root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
end

PhotoFrame::Server.configure do |c|
  c.views = PhotoFrame.root.join("views")
  c.public_folder = PhotoFrame.root.join("public")
end