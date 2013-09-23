require 'sinatra/base'

class PhotoFrame
  class Server < Sinatra::Base

    include Library

    get '/' do
      @images = secure_files
      erb :index
    end

    get '/fetch' do
      binding.pry
    end
  end
end
