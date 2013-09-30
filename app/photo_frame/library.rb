require 'base64'

class PhotoFrame
  module Library
    def files
      @files ||= all_files
    end

    def path_files
      dir_lists = PhotoFrame.config.paths.map do |pattern|
        Dir.glob pattern
      end
      dir_lists.reduce(:+)
    end

    def all_files
      files = path_files.select do |file|
        PhotoFrame.config.patterns.any? do |pattern|
          file =~ pattern
        end
      end
      PhotoFrame.config.shuffle ? files.shuffle : files
    end

    def secure_files
      @secure_files ||= files.map do |file|
        Base64.urlsafe_encode64 file.encrypt(key: PhotoFrame.config.secret)
      end
    end

    def secure_fetch(secure_path)
      encrypted_path = Base64.urlsafe_decode64( secure_path )
      send_file encrypted_path.decrypt(key: PhotoFrame.config.secret)
    end
  end
end
