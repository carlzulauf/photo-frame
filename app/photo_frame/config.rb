require 'singleton'

class PhotoFrame
  class Config
    include Singleton

    attr_accessor :paths, :patterns, :secret
    attr_reader :root

    def initialize
      self.paths, self.patterns = [], []
    end

    def root=(path)
      @root = path
      @root.send(:extend, Root)
    end

    module Root
      def join(*args)
        File.join(self, *args)
      end
    end
  end
end
