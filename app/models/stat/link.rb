##
# = 商城 链接 表
#
# == Fields
#
# editor_id :: 编辑ID
# ad_id :: 广告ID
# name :: 名称
# description :: 描述
# url :: 地址
# active? :: 有效？
#
# == Indexes
#
class Stat::Link < ActiveRecord::Base
  self.table_name = "stat_links"

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  # belongs_to :ad
  has_many :clicks
  has_many :trades
  # has_many :accounts, :class_name => "Core::Account"
  has_many :latest_trades, class_name: "Shop::Trade", foreign_key: 'latest_link_id'
  # has_many :latest_accounts, class_name: "Core::Account", foreign_key: 'latest_link_id'

  scope :active, ->{where :active => true }

  SOURCES = { 'email' => '邮件', 'msn' => 'MSN中国', 'cmbchina' => '招商银行' }
end
