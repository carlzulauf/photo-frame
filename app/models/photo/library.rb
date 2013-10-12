class Photo::Library

  attr_reader :paths, :patterns

  def initialize(paths, patterns)
    @paths    = paths
    @patterns = patterns
  end

  def rebuild
    Photo.delete_all
    build
  end

  def build
    files = all_files
    puts "Processing #{all_files.count} files..."
    progress = ProgressBar.new("Photos", all_files.count)
    Photo.transaction do
      all_files.each do |file|
        progress.inc
        Photo.create!(
          path: file,
          token: SecureRandom.hex(16),
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
        if patterns.empty? || patterns.any?{ |p| file =~ p }
          all << file
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
