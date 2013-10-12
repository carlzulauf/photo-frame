class PhotoFrame
  class Server < Sinatra::Base

    include Library

    register Sinatra::AssetPipeline
    register Sinatra::ActiveRecordExtension

    get '/' do
      @images = secure_files
      haml :index
    end

    get '/fetch' do
      secure_fetch params[:file]
    end
  end
end
