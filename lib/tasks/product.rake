namespace :shop do
  namespace :product do
    desc 'sync_sell_data_periodical'
    task :sync_sell_data_periodical => :environment do
      File.open(ENV['PIDFILE'], 'w') { |f| f << Process.pid } if ENV['PIDFILE']
      while (1)
        begin
          Shop::Product.active.published.each(&:sync_sell_data!)
          sleep 300

          l = "shop_product_sync_sell_data"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "shop_product_sync_sell_data_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end

    desc 'sync_sell_data'
    task :sync_sell_data => :environment do
      Shop::Product.active.published.each(&:sync_sell_data!)

      l = "shop_product_sync_sell_data"
      Rails.logger.info l
      puts l
    end

    desc 'sync_items_data start=0 end=0 (产品id 参数可选)'
    task :sync_items_data => :environment do
      ActiveRecord::Base.connection.execute("UPDATE `shop_products` SET identifier = NULL where identifier = ''")
      Shop::Product.active.where(ENV["start"] && ["id >= ?", ENV["start"]]).where(ENV["end"] && ["id <= ?", ENV["end"]]).where("identifier IS NULL").find_each(:batch_size => 100) do |product|
        begin
          product.sync!
          l = "shop_product_sync_items_data #{product.id}"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "shop_product_sync_error #{product.id} #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
      l = "shop_product_sync_items_data"
      Rails.logger.info l
    end

    desc 'initialize_shop_price'
    task :initialize_shop_price => :environment do
      Shop::Product.update_all "shop_price = IF(discount<10, discount, IF(discount/0.9 >= price, discount, ROUND(discount/9)*10))"
    end
  end

  namespace :call do
    desc 'sync'
    task :sync, [:started_at, :ended_at] => :environment do |t, params|
      Shop::Call.sync!(:started_at => params[:started_at] && Time.parse(params[:started_at]), :ended_at => params[:ended_at] && Time.parse(params[:ended_at]))
    end
  end
end
