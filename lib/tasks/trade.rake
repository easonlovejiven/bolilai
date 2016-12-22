namespace :shop do
  namespace :trade do
    desc 'try_punish_periodical'
    task :try_punish_periodical => :environment do
      File.open(ENV['PIDFILE'], 'w') { |f| f << Process.pid } if ENV['PIDFILE']
      while (1)
        begin
          do_try_punish
          sleep 300

          l = "rake_shop_trade_try_punish_periodical"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "rake_shop_trade_try_punish_periodical_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end

    desc 'try_punish'
    task :try_punish => :environment do
      do_try_punish
    end

    def do_try_punish
      Shop::Trade.where(["status = ? AND created_at < ?", 'pay', 2.hours.ago]).each do |trade|
        begin
          ActiveRecord::Base.transaction do
            trade.try_query_payment!
            trade.try_punish!
          end

          l = "rake_shop_trade_try_punish #{trade.id}"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "rake_shop_trade_try_punish_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end

    desc 'try_query_payment_periodical'
    task :try_query_payment_periodical => :environment do
      while (1)
        begin
          do_try_query_payment
          sleep 300

          l = "rake_shop_trade_try_punish_periodical"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "rake_shop_trade_try_punish_periodical_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end
    desc 'try_query_payment'
    task :try_query_payment => :environment do
      do_try_query_payment
    end

    def do_try_query_payment
      Shop::Trade.where(["status = ?", 'pay']).each do |trade|
        begin
          ActiveRecord::Base.transaction do
            trade.try_query_payment!
          end

          l = "rake_shop_trade_try_query_payment #{trade.id}"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "rake_shop_trade_try_query_payment_error #{e.inspect}\n#{e.backtrace.join("\n")}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end

    desc '查询创建2-8天的待收货或已完成交易'
    task :query_delivery_received_at => :environment do
      Shop::Trade.where(["(status = ? OR status = ?) AND created_at BETWEEN ? AND  ? AND delivery_received_at IS ? AND delivery_service IN (?)", 'receive', 'complete', 8.days.ago.midnight, 1.days.ago.midnight, nil, %w[zjs fedex sf]]).find_each do |trade|
        begin
          trade.trade_delivery_result
          l = "rake_shop_trade_query_delivery_received_date #{trade.id}"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "rake_shop_trade_query_delivery_received_date_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end


    desc 'transfer'
    task :transfer => :environment do
      Shop::Trade.all.map do |trade|
        begin
          ActiveRecord::Base.transaction do
            unit = Shop::Unit.where(trade_id: trade.id, item_id: trade.item_id).first_or_initialize
            unit.update_attributes!(
                # :circle_id => trade.circle_id,
                :price => trade.price,
                :percent => trade.percent,
                :point => trade.point,
                # :bonus => trade.bonus,
                # :contributed => !!(trade.circle_id || trade.note_id),
                :returned => %[cancel punished freezed return].include?(trade.status)
            )
            trade.update_attributes!(:status => "complete") if %w[contribute accept reject].include?(trade.status)
            trade.update_attributes!(:status => "freezed") if %w[return].include?(trade.status)
          end

          l = "rake_shop_trade_transfer #{trade.id}"
          Rails.logger.info l
          puts l
        rescue Exception => e
          l = "rake_shop_trade_transfer_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
    end

    desc 'amount'
    task :amount => :environment do
      units = Shop::Unit.joins("JOIN shop_trades ON shop_trades.id = shop_units.trade_id AND shop_trades.created_at < #{Shop::Unit.sanitize(2.weeks.ago.to_s(:db))} AND (shop_trades.status = 'complete' OR shop_trades.status = 'receive') AND shop_trades.user_id IS NOT NULL").where("shop_units.returned = FALSE")
      units.where('shop_units.shop_point_added = FALSE').each do |u|
        begin
          ActiveRecord::Base.transaction do
            unit = u.class.find(u.id)
            unit.update_attributes!(:shop_point_added => true)
            user = unit.trade.user
            user.update_attributes!(:trades_point => user.trades_point.to_i + unit.price)
            user.updatings.create!(:trades_point => user.trades_point)
          end
        rescue Exception => e
          l = "rake_shop_trade_amount_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end
      Shop::User.select("shop_users.*, SUM(shop_units.price) AS s").joins("LEFT JOIN shop_trades ON shop_users.id = shop_trades.user_id AND shop_trades.created_at < #{Shop::User.sanitize(2.weeks.ago.to_s(:db))} AND (shop_trades.status = 'complete' OR shop_trades.status = 'receive') LEFT JOIN shop_units ON shop_units.trade_id = shop_trades.id AND shop_units.returned = FALSE").group("shop_users.id").each do |u|
        begin
          ActiveRecord::Base.transaction do
            user = u.class.find(u.id)
            user.trades_price_sum = u.s
            level = Shop::Level.active.where(["limitation <= ?", user.trades_point.to_i + user.level.limitation]).order("limitation DESC").first if user.level
            user.suggested_level = !level ? nil : level.limitation > user.level.limitation ? level : level.limitation.to_i != 0 && user.level_modified_at? && Time.now - user.level_modified_at > 1.years ? user.trades_point.to_i >= user.level.reservation ? user.level : Shop::Level.active.first(:conditions => ["limitation <= ?", user.level.limitation - 1], :order => "limitation DESC") : nil
            user.save! if user.changed?
          end
        rescue Exception => e
          l = "rake_shop_trade_amount_error #{e.inspect}\n#{e.backtrace.join("\n")}"
          Rails.logger.info l
          puts l
        end
      end

    end

    desc 'init trade level_percent and point_percent'
    task :init_trade_level_percent_and_point_percent => :environment do
      Shop::Unit.where('percent IS NOT NULL AND point > 0').update_all('point_percent = percent')
      Shop::Unit.where('percent IS NOT NULL AND (point = 0 OR point IS NULL) AND multibuy_id IS NULL').update_all('level_percent = percent')
    end

  end
end
