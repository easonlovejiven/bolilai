class AddTmplToPages < ActiveRecord::Migration
  def change
    add_column "custom_page_pages", :tmpl,:boolean, :default=>false
  end
end
