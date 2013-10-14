require 'sinatra'

FRAMEWORK_PATH = "/opt/PalmSDK/0.1/share/framework/"
ENYO_PATH = File.join(FRAMEWORK_PATH, "enyo", "1.0", "framework")
set :public_folder, File.dirname(__FILE__)

get '/' do
  send_file 'index.html'
end

get '/framework_config.json' do
  send_file File.join(ENYO_PATH, "framework_config.json")
end

get %r{^/framework/(.+)} do |framework_file|
  send_file File.join(FRAMEWORK_PATH, framework_file)
end
