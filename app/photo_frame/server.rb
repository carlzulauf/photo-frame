require 'sinatra/base'

class PhotoFrame
  class Server < Sinatra::Base

    include Library

    register Sinatra::AssetPipeline

    get '/' do
      @images = secure_files
      haml :index
    end

    get '/fetch' do
      secure_fetch params[:file]
    end
  end
end
