module Mobile::ApplicationHelper
 def sort_mapping
   {"default"=>"默认排序", "price_asc"=>"价格上升", "price_desc"=>"价格下降", "readings_count_desc"=>"人气", "scarcity_desc"=>"限量", "percent_asc"=>"折扣", "arrived_at_desc"=>"上架时间"}
 end
end
