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

          desc "Compile assets to webos app"
          task :webos do
            environment = app.sprockets
            app     = PhotoFrame.root.join("webos", "source", "PhotoFrame.js")
            vendor  = PhotoFrame.root.join("webos", "source", "vendor.js")
            css     = PhotoFrame.root.join("webos", "css", "app.css")
            environment[ "app.js"    ].write_to app
            environment[ "vendor.js" ].write_to vendor
            environment[ "app.css"   ].write_to css
          end
        end
      end

      def self.define!(app)
        self.new app
      end
    end
  end
end
