class CoreTransactions < ActiveRecord::Migration
  def change
    create_table "core_transactions" do |t|
      t.integer  "user_id"
      t.integer  "point"
      t.integer  "gene_point"
      t.integer  "auction_point"
      t.integer  "incremented"
      t.text     "description"
      t.boolean  "active",        :default => true
      t.datetime "destroyed_at"
      t.datetime "created_at",                      :null => false
      t.datetime "updated_at",                      :null => false
      t.integer  "editor_id"
    end
  end
end
