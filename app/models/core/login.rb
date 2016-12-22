##
# = 主站 登录 表
#
# == Fields
#
# user_id :: 用户id
# login_on :: 登录日期
# ip_address :: ip地址
#
# == Indexes
#
# user_id, login_on
#
class Core::Login < ActiveRecord::Base
	self.table_name = :core_logins

	# index [ :user_id, :login_on ]

	belongs_to :user
end
