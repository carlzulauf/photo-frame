require 'rake'
require 'rake/tasklib'
require 'rake/sprocketstask'

class PhotoFrame
  module Tasks
    class Assets < Rake::TaskLib
      def initialize(app)
        namespace :assets do
          desc "Precompile everything"
          task :pry do
            environment = app.sprockets
            # manifest = Sprockets::Manifest.new(environment.index, app.assets_path)
            # manifest.compile(app.assets_precompile)
            binding.pry
          end
        end
      end

      def self.define!(app)
        self.new app
      end
    end
  end
end
