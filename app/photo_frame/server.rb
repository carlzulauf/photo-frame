class PhotoFrame
  class Server < Sinatra::Base
    register Sinatra::AssetPipeline
    register Sinatra::ActiveRecordExtension

    helpers Sinatra::Jsonp

    get '/' do
      haml :index
    end

    get '/photos.json' do
      photos = Photo.random.limit(20).select do |photo|
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
      if params[:width] && params[:height]
        width = params[:width].to_i
        height = params[:height].to_i
        geometry = "#{params[:width]}x#{params[:height]}"
        image = image.change_geometry(geometry) do |w,h,img|
          top = h < height ? (height - h) / 2 : 0
          left = w < width ? (width - w) / 2 : 0
          img.background_color = "#000"
          img = img.resize(w,h)
          img.extent(width, height, -left, -top)
        end
      end
      image.to_blob
    end
  end
end
