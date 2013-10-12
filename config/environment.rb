$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

Bundler.require

require 'json'
require 'securerandom'
require 'photo_frame'
require 'pry'
require 'progressbar'
require 'RMagick'
require 'sinatra/base'
require "sinatra/jsonp"
require 'sinatra/activerecord'

PhotoFrame.config do |config|
  config.paths << "/home/carl/Pictures/**/*"
  config.patterns << ( /\.(jpe?g|png)/i )
  config.shuffle = true
  config.secret = "f1c693e4ac47ed5c4cbcb9a3a0c015fd659502b93ca26f35dae49fec6ed82589"
  config.root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
end

PhotoFrame::Server.configure do |c|
  c.views = PhotoFrame.root.join("views")
  c.public_folder = PhotoFrame.root.join("public")
  c.assets_precompile = %w(app.js app.css vendor.js vendor.css *.png *.jpg *.svg *.eot *.ttf *.woff)
end

DB_CONFIG = YAML.load_file PhotoFrame.root.join("config", "database.yml")
$database = ActiveRecord::Base.establish_connection(DB_CONFIG)
