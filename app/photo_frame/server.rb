class PhotoFrame
  class Server < Sinatra::Base
    register Sinatra::AssetPipeline
    register Sinatra::ActiveRecordExtension

    helpers Sinatra::Jsonp

    get '/' do
      haml :index
    end

    get '/photos.json' do
      photos = Photo.random.limit(100).select do |photo|
        {
          name: photo.path,
          token: photo.token
        }
      end
      jsonp({photos: photos})
    end

    get '/fetch/:token' do
      photo = Photo.where(token: params[:token]).first
      image = Magick::Image.read(photo.path).first
      content_type image.mime_type
      image.auto_orient!
      image.to_blob
    end
  end
end
