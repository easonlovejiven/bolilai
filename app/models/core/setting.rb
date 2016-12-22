##
# = 主站 设置 表
#
# == Fields
#
# profile :: 个人主页
# friend :: 好友
# feed :: 新鲜事
# basic :: 基本信息
# personal :: 个人信息
# work :: 工作信息
# im :: MSN
# mobile :: 手机
# phone :: 电话
# website :: 网站
# email :: 邮件
# search :: 搜索
# my_profile_picture? :: 头像？
# my_friend_list? :: 朋友列表？
# a_link_to_add_me_as_a_friend? :: 加好友？
# a_link_to_send_me_a_message? :: 发信息？
# search_engine_indexing? :: 搜索引擎？
# sends_me_a_message? :: 发送信息给我？
# adds_me_as_a_friend? :: 加我好友？
# confirms_a_friendship_request? :: 确认好友请求？
# suggests_a_friend_to_me? :: 建议好友？
# adds_a_friend_i_suggested? :: 加我建议的好友？
# i_invited_joins_facebook? :: 邀请的人注册？
# has_a_birthday_coming_up? :: 生日快到？
# pokes_me? :: 打招呼？
# posts_on_my_wall? :: 在我的主页留言？
# comments_on_a_story_in_my_wall? :: 评论我的新鲜事？
# comments_after_me_on_a_wall_story? :: 评论我出现过的新鲜事？
# public_online_status? :: 显示在线？
# receive_promotion_email? :: 接受悦购推广邮件？
# receive_promotion_email_of_event? :: 接收活动邮件？
# receive_promotion_email_of_voucher? :: 接收代金券邮件？
# receive_promotion_email_of_news? :: 接收资讯邮件？
# receive_promotion_email_of_recommend? :: 接收推荐邮件？
# receive_promotion_sms_of_event? :: 接收活动短信？
# receive_promotion_sms_of_voucher? :: 接收代金券短信？
# receive_promotion_sms_of_promot? :: 接收提示短信？
#
# == Indexes
#
class Core::Setting < ActiveRecord::Base
	self.table_name = :core_settings

	belongs_to :user, :foreign_key => :id
	has_many :updatings, :class_name => "Core::SettingUpdating"

	self.xml_options = { :only => [ :search_engine_indexing, :profile, :friend, :basic, :im, :note, :photo, :share, :sends_me_a_message, :adds_me_as_a_friend, :confirms_a_friendship_request, :suggests_a_friend_to_me, :adds_a_friend_i_suggested, :i_invited_joins_facebook, :pokes_me, :posts_on_my_wall, :comments_on_a_story_in_my_wall, :comments_after_me_on_a_wall_story , :public_online_status, :receive_promotion_email, :receive_promotion_email_of_event, :receive_promotion_email_of_voucher, :receive_promotion_email_of_news, :receive_promotion_email_of_recommend, :receive_promotion_sms_of_event, :receive_promotion_sms_of_voucher, :receive_promotion_sms_of_promote ] }

	def privacy_level(method) # :nodoc: all
		raise "没有#{method}这个隐私"  unless self.respond_to?(method)
		ActiveSupport::JSON.decode(self.send(method.to_s))
	end
end
