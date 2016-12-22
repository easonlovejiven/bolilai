NonStupidDigestAssets.whitelist += [/ueditor\/.*/]

Rails.application.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
Rails.application.config.assets.precompile.unshift('plugins/ueditor/ueditor.all.js')
# Rails.application.config.assets.precompile += %w(Respond-1.4.2/respond.min.js )
Rails.application.config.assets.precompile += %w(core/modernizr.js core/html5shiv.js )
Rails.application.config.assets.precompile += %w(mobile.css)
Rails.application.config.assets.precompile += %w(application_landing.css application_landing.js application_rest.css application_rest.js)
Rails.application.config.assets.precompile += %w(admin/sessions/application.css admin/sessions/application.js )
Rails.application.config.assets.precompile += %w( core/jquery-1.9.1.min.js )
Rails.application.config.assets.precompile += %w(admin/shop/print.css)
# Rails.application.config.assets.precompile += %w(admin/custom_page/customizer.css admin/custom_page/customizer.js admin/custom_page/preview.css admin/custom_page/preview.js admin/custom_page/series_preview.js)
paths=[]
dirs=[
    ["app/assets/stylesheets/", "custom_page/**/*.*"],
    ["app/assets/javascripts/", "plugins/ueditor/**/*.*"],
    ["app/assets/stylesheets/", "admin/custom_page/**/*.*"],
    ["app/assets/stylesheets/", "mobile/**/*.*"],
    ["app/assets/javascripts/", "admin/custom_page/**/*.*"],
    ["app/assets/javascripts/", "admin/manage/roles.js"],
    ["app/assets/javascripts/", "mobile/**/*.*"],
    ["app/assets/stylesheets/", "admin/custom_page/pages/**/*.*"]
]
paths += dirs.map { |base, name| Dir["#{Rails.root}/#{base}#{name}"].map { |path| path.gsub("#{Rails.root}/#{base}", '').gsub(/\.(coffee|scss|sass|erb)/, '') } }.flatten
Rails.application.config.assets.precompile += paths
