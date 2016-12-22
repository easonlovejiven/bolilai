##
# = 商城 优惠码 表
#
# == Fields
#
# editor_id :: 编辑ID
# code :: 代码
# name :: 名称
# description :: 描述
# started_at :: 开始时间
# ended_at :: 结束时间
# limitation :: 限制次数
# function :: 功能，必须为{ 'add_point' => '加积分', 'add_voucher' => '加代金券', 'add_point_and_voucher' => '加积分和代金券', } 之一
# point :: 积分
# event_id :: 活动ID
# event_ids :: 活动ID列表（用换行分隔）
# published? :: 发布？
# active? :: 有效？
#
# == Indexes
#
# acitve, published, code
#
class Shop::Coupon < ActiveRecord::Base
	self.table_name = :shop_coupons

	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
	belongs_to :event
	has_many :usages

	scope :active, -> {where :active => true }
	scope :published,->{where :published => true }

	self.xml_options = { :only => [ :id, :code, :name, :description, :started_at, :ended_at ] }

	FUNCTION = { 'add_point' => '加积分', 'add_voucher' => '加代金券', 'add_point_and_voucher' => '加积分和代金券' }

	def available? #:nodoc: all
		self.active? && self.published? && self.started_at && self.ended_at && Time.now > self.started_at && Time.now < self.ended_at
	end

	def use_by! user
		ActiveRecord::Base.transaction do
			return if self.usages.first(:conditions => ["user_id = ?", user.id])
			self.usages.create!(:user_id => user.id)
			case self.function
			when 'add_point'
				Core::User.find(user.id).do_transaction!(self.point, "优惠券#{self.code}加分") if self.point && self.point > 0
			when 'add_voucher'
				(self.event_ids || '').split.map(&:to_i).push(self.event_id).compact.map{|id| Shop::Event.active.find_by_id(id)}.compact.each do |e|
					Shop::Voucher.create!(:event => e, :user_id => user.id, :remark => "优惠券#{self.code}加代金券", :obtained_at => Time.now) if e && e.active? && Time.now < e.ended_at
				end
			when 'add_point_and_voucher'
				Core::User.find(user.id).do_transaction!(self.point, "优惠券#{self.code}加分") if self.point && self.point > 0
				(self.event_ids || '').split.map(&:to_i).push(self.event_id).compact.map{|id| Shop::Event.active.find_by_id(id)}.compact.each do |e|
					Shop::Voucher.create!(:event => e, :user_id => user.id, :remark => "优惠券#{self.code}加代金券", :obtained_at => Time.now) if e && e.active? && Time.now < e.ended_at
				end
			end
		end
	end

	def use_by user
		self.use_by!(user) rescue nil
	end
end
