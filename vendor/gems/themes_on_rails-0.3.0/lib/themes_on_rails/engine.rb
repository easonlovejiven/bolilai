require 'rails/generators'

module ThemesOnRails
  class Engine < ::Rails::Engine
    initializer 'themes_on_rails.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        include ThemesOnRails::ControllerAdditions
        prepend_view_path Dir.glob("#{Rails.root}/app/themes/*/views")
      end
    end

    initializer 'themes_on_rails.load_locales' do |app|
      # app.config.i18n.default_locale = :en
      app.config.i18n.load_path += Dir[Rails.root.join('app/themes/*', 'locales', '**', '*.yml').to_s]
    end

    initializer 'themes_on_rails.assets_path' do |app|
      Dir.glob("#{Rails.root}/app/themes/*/assets/*").each do |dir|
        # puts "======#{dir}"
        app.config.assets.paths << dir
      end
    end

    initializer 'themes_on_rails.precompile' do |app|
      app.config.assets.precompile += [ Proc.new { |path, fn| fn =~ /app\/themes/ && !%w(.js .css).include?(File.extname(path)) } ]
      # app.config.assets.precompile += Dir['app/themes/*'].map { |path| "#{path.split('/').last}/all.js" }
      # app.config.assets.precompile += Dir['app/themes/*'].map { |path| "#{path.split('/').last}/all.css" }
      dirs=[["app/themes/touch/assets/stylesheets/", "touch/**/*.*"],["app/themes/touch/assets/javascripts/", "touch/**/*.*"]]
      paths=dirs.map { |base, name| Dir["#{Rails.root}/#{base}#{name}"].map { |path| path.gsub("#{Rails.root}/#{base}", '').gsub(/\.(coffee|scss|sass|erb)/, '') } }.flatten
      puts "#####{paths}"
      app.config.assets.precompile+=paths
    end
  end
end
