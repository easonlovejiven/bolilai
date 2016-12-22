class CreateSimpleCaptchaData < ActiveRecord::Migration
  def change
    create_table "simple_captcha_data" do |t|
      t.string   "key",        :limit => 40
      t.string   "value",      :limit => 6
      t.datetime "created_at",               :null => false
      t.datetime "updated_at",               :null => false
    end

    add_index "simple_captcha_data", ["key"], :name => "index_simple_captcha_data_on_key"
  end
end
