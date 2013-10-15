class Photo::Library

  attr_reader :paths, :patterns

  def initialize(paths, patterns)
    @paths    = paths
    @patterns = patterns
  end

  def rebuild
    build do
      Photo.delete_all
    end
  end

  def build
    files = all_files
    puts "Processing #{all_files.count} files..."
    progress = ProgressBar.new("Photos", all_files.count)
    Photo.transaction do
      yield if block_given?
      all_files.each do |file|
        progress.inc
        Photo.create!(
          path: file,
          token: Digest::MD5.hexdigest(file),
          file_size: File.size(file)
        )
      end
    end
    progress.finish
  end

  def all_files
    all = []
    paths.each do |path_pattern|
      Dir.glob(path_pattern).each do |file|
        all << file if patterns.empty? || patterns.any?{ |p| file =~ p }
      end
    end
    all
  end

  def self.build
    library = self.new PhotoFrame.config.paths, PhotoFrame.config.patterns
    library.rebuild
  end
end
