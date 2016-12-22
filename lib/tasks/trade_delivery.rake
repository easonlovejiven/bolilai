namespace :shop do
  namespace :trade do
    desc 'delivery_reconcile'
    task :delivery_reconcile => :environment do
      def delivery_encrypt(string)
        cipher = OpenSSL::Cipher::Cipher.new("DES-ECB")
        cipher.encrypt
        cipher.key = Base64.decode64(DELIVERY_CONFIG['bill99']['key'])
        cipher.update(string) << cipher.final
      end

      def delivery_decrypt(string)
        cipher = OpenSSL::Cipher::Cipher.new("DES-ECB")
        cipher.decrypt
        cipher.key = Base64.decode64(DELIVERY_CONFIG['bill99']['key'])
        cipher.update(string) << cipher.final
      end

      def delivery_download(path)
        file = Tempfile.new(Time.now.to_i.to_s)

        ftp = Net::FTP.new(DELIVERY_CONFIG['bill99']['host'], DELIVERY_CONFIG['bill99']['username'], DELIVERY_CONFIG['bill99']['password'])
        ftp.passive = true
        ftp.getbinaryfile(path, file.path)
        ftp.close

        result = file.read
        file.close
        file.unlink

        result
      end

      def delivery_upload(path, string)
        file = Tempfile.new(Time.now.to_i.to_s)
        file.binmode
        file.write(string)
        file.rewind

        ftp = Net::FTP.new(DELIVERY_CONFIG['bill99']['host'], DELIVERY_CONFIG['bill99']['username'], DELIVERY_CONFIG['bill99']['password'])
        ftp.passive = true
        path.scan(/.\//).size.times { |i| dir = path.split('/')[0..i+1].join('/'); ftp.mkdir(dir) if (ftp.chdir(dir) rescue true) }
        ftp.storbinary("STOR #{path}", file, Net::FTP::DEFAULT_BLOCKSIZE)
        ftp.close

        file.close
        file.unlink
      end

      def delivery_zip(string, filename = "reconResult.csv")
        file = Tempfile.new(Time.now.to_i.to_s)

        io = Zip::ZipOutputStream.new(file)
        io.put_next_entry(filename)
        io.write(string)
        io.close

        result = file.read

        file.close
        file.unlink

        result
      end

      def delivery_unzip(string)
        file = Tempfile.new(Time.now.to_i.to_s)
        file.binmode
        file.write(string)
        file.rewind

        io = Zip::ZipInputStream.new(file)
        io.get_next_entry
        result = io.read.toutf8
        io.close

        file.close
        file.unlink

        result
      end

      def delivery_get(path)
        CSV.parse(delivery_unzip(delivery_decrypt(delivery_download(path))))
      end

      def delivery_put(path, data)
        delivery_upload(path, delivery_encrypt(delivery_zip("\357\273\277"+data.map(&:to_csv).join)))
      end

      def delivery_exist(path)
        ftp = Net::FTP.new(DELIVERY_CONFIG['bill99']['host'], DELIVERY_CONFIG['bill99']['username'], DELIVERY_CONFIG['bill99']['password'])
        ftp.passive = true
        result = ftp.nlst(path)
        ftp.close
        !result.blank?
      end

      config = DELIVERY_CONFIG['bill99']
      weimall_identifier = config['weimall_identifier']
      weimall_name = config['weimall_name']
      fedex_identifier = config['fedex_identifier']
      fedex_name = config['fedex_name']
      date = Time.now.to_date

      path = "/kq/#{weimall_identifier}/#{date.strftime("%Y%m%d")}/settleDetail.enc"
      if delivery_exist(path)
        data = delivery_get(path)
        trades = data[1..-1].map do |d|
          if trade = Shop::Trade.find_by_delivery_service_and_delivery_identifier('fedex', d[0])
            trade.delivery_settled_amount = d[7]
            trade.delivery_settled_at = d[9]
            trade.save
            trade
          end
        end
      end

      path = "/kq/#{weimall_identifier}/#{date.strftime("%Y%m%d")}/remitDetail.enc"
      if delivery_exist(path)
        data = delivery_get(path)
        trades = data[1..-1].map do |d|
          if trade = Shop::Trade.find_by_delivery_service_and_delivery_identifier('fedex', d[0])
            trade.delivery_receipted_amount = d[7]
            trade.delivery_receipted_at = d[8]
            trade.delivery_remitted_at = d[9]
            trade.save
            trade
          end
        end
        title_data = [%w[运单号 物流公司商户号 物流公司名称 托运人编号 托运人名称 交易类型 收款方式 快钱金额 对账金额 对账日期 对账结果]]
        fedex_data = data[1..-1].each_with_index.map { |d, i| d[0..7] + [trades[i] ? trades[i].price : nil, Time.now.to_date.strftime("%Y-%m-%d"), !trades[i] ? 1 : trades[i].price == d[7].to_i ? 0 : 3] }
        weimall_data = (Shop::Trade.where(["payment_service = 'express' AND delivery_service = 'fedex' AND (ship_at BETWEEN ? AND ?)", 7.days.ago.yesterday.at_beginning_of_day, 7.days.ago.yesterday.end_of_day]) - trades).map { |trade| [trade.delivery_identifier, fedex_identifier, fedex_name, weimall_identifier, weimall_name, nil, nil, nil, trade.price, Time.now.to_date.strftime("%Y-%m-%d"), 2] }
        delivery_put("/me/#{weimall_identifier}/#{date.strftime("%Y%m%d")}/reconResult.enc", title_data+fedex_data+weimall_data)
        trades.compact.each { |trade| trade.update_attributes(:delivery_reconciled_at => Time.now) }

        fedex_data.each { |d| d[0] = "\t#{d[0]}"; d[1] = "\t#{d[1]}"; d[3] = "\t#{d[3]}" }
        weimall_data.each { |d| d[0] = "\t#{d[0]}"; d[1] = "\t#{d[1]}"; d[3] = "\t#{d[3]}" }
        Core::Mailer.mail(:recipients => config['recipients_complete'], :subject => "FedEx Reconciliation Results of #{date.to_s(:db)}", :attachment => {:content_type => 'text/csv', :filename => 'reconResult.csv', :body => "\357\273\277"+(title_data+fedex_data+weimall_data).map(&:to_csv).join})
        Core::Mailer.mail(:recipients => config['recipients_incorrect'], :subject => "FedEx Reconciliation Results of #{date.to_s(:db)}", :attachment => {:content_type => 'text/csv', :filename => 'reconResult.csv', :body => "\357\273\277"+(title_data+fedex_data.select { |d| d[10]!=0 }+weimall_data).map(&:to_csv).join})
      end
    end
  end
end
