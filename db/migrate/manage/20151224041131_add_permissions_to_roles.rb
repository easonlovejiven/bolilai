class AddPermissionsToRoles < ActiveRecord::Migration
  def change
    %w{
      shop_product
      shop_attribute
      shop_item
      shop_unit
      shop_trade
      shop_category
      shop_coupon
      shop_contact
      shop_brand
      shop_comment
      shop_event
      shop_level
      shop_mail
      custom_page_page
      shop_sms
      shop_user
      shop_voucher
      shop_preference
      cms_category
      cms_page
      core_user
      core_account
      core_comment
      core_transaction
      manage_grant
      manage_editor
      manage_role
      manage_user
      manage_log}.each do |column|
      add_column :manage_roles, column, :integer, default: 0
    end
  end
end
