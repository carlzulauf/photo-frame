require 'sinatra/base'

class PhotoFrame
  class Server < Sinatra::Base

    include Library

    get '/' do
      @images = secure_files
      erb :index
    end

    get '/fetch' do
      secure_fetch params[:file]
    end
  end
end
