# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# admin=User.find_or_create_by!(email: "admin@gmail.com") do |user|
#   user.name = '超级管理员'
#   user.nickname = 'admin'
#   user.role='admin'
#   user.password = '123456'
#   user.password_confirmation = '123456'
# end
#
#
# normal=User.find_or_create_by!(email: "user@gmail.com") do |user|
#   user.name = '普通用户'
#   user.nickname = 'test'
#   user.role='normal'
#   user.password = '123456'
#   user.password_confirmation = '123456'
# end
# account=Core::Account.create! :id => 1, :email => 'test@gmail.com', :password => '123456', :password_confirmation => '123456',
#                               :user => (Core::User.create :id => 1, :name => 'test', :sex => 'male', :birthday => '1980-10-15'),
#                               :info => (Core::Info.create :id => 1)

user = Manage::User.create id: account.id, name: '管理员'
role = Manage::Role.create name: '管理员', manage_grant: 127, manage_editor: 127, manage_role: 127
editor = Manage::Editor.create id: user.id, identifier: account.email, name: '管理员', role_id: role.id

CustomPage::Page.where(name: "移动端首页", position: "mobile_root", engine: "template", active: true, published: true, content: '{"version": "mobile_root_1"}').first_or_create!

