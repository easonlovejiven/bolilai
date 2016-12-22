#every 1.day, :at => '12:01 pm' do
#  runner 'WheneverWorker.perform_async'
#end
#whenever --update-crontab  damentu
require "yaml"
set :environment, 'production'
SOLR_CONFIG = YAML::load_file("#{Dir.getwd}/config/solr.yml")["production"]

set :output, './log/schedule.log'
job_type :command, ":task"

every 5.minutes do
  rake 'shop:trade:try_punish'
  rake 'shop:product:sync_sell_data'
end

every 30.minutes do
  rake 'cache:refresh["3  / /home /shop/brands /shop/categories"]'
  # rake 'shop:product:sync_items_data'
  rake 'shop:trade:amount'
  rake 'shop:sync_synonym'
  command "curl http://#{SOLR_CONFIG["host"]}:#{SOLR_CONFIG["port"]}/solr/product/dataimport\?command=full-import"
end
