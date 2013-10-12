require './config/environment'
require 'sinatra/asset_pipeline/task.rb'
require "sinatra/activerecord/rake"
require "tasks/assets"

Sinatra::AssetPipeline::Task.define! PhotoFrame::Server
PhotoFrame::Tasks::Assets.define! PhotoFrame::Server

namespace :library do
  desc "Build/rebuild the library"
  task :build do
    Photo::Library.build
  end
end

task :pry do |app|
  binding.pry
end
