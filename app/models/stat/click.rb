##
# = 商城 点击 表
#
# == Fields
#
# link_id :: 链接ID
# user_id :: 用户ID
# referrer :: 来源
# ip :: IP地址
# agent :: 浏览器
# url :: 访问地址
# path :: 请求地址
# active? :: 有效？
#
# == Indexes
#
# link_id
#
class Stat::Click < ActiveRecord::Base
  self.table_name = "stat_clicks"

  belongs_to :link
  belongs_to :user
end
