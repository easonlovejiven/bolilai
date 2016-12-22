#
# == Function
#
# 消息主题
#
# == Fields
#
# app_id ::	应用id
# name ::	名称
# description ::	描述
# icon ::	图标
# quota ::	限额
# limit ::	限次
# period ::	周期
# created_at :: 创建时间
# updated_at :: 更新时间
#

class Core::Trade < ActiveRecord::Base # :nodoc: all
  self.table_name = :core_trades

  # belongs_to :transaction, :foreign_key => :id,class_name: "Core::Transaction"
end
