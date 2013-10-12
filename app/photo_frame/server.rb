class PhotoFrame
  class Server < Sinatra::Base

    include Library

    register Sinatra::AssetPipeline
    register Sinatra::ActiveRecordExtension

    get '/' do
      haml :index
    end

    get '/photos.json' do
      {photos: Photo.random.limit(100).map(&:token)}.to_json
    end

    get '/fetch/:token' do
      photo = Photo.where(token: params[:token]).first
      send_file photo.path
    end
  end
end
