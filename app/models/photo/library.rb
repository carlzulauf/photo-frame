class Photo::Library

  def initialize(paths, patterns)
    @paths    = paths
    @patterns = patterns
  end

  def rebuild
    Photo.delete_all
    build
  end

  def build

  end

  def all_files
    all = []
    paths.each do |path_pattern|
      Dir.glob(path_pattern).each do |file|
        if patterns.empty? || patterns.any?{|p| file =~ p }
          if block_given?
            yield
          else
            all << file
          end
        end
      end
    end
    all
  end

  def self.build
    library = self.new PhotoFrame.config.paths, PhotoFrame.config.patterns
    library.rebuild
  end
end
