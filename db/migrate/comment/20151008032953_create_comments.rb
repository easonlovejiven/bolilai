class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  'user_id',                        null: false
      t.integer  'editor_id',                      null: false
      t.integer  'parent_id'
      t.integer  'commentable_id',                 null: false
      t.string   'commentable_type',               null: false
      t.string   'title',                          null: false
      t.text     'body',                           null: false
      t.string   'ip'
      t.boolean 'active',       default: true,     null: false
      t.integer "lock_version", default: 0,        null: false
      t.integer  'score'
      t.integer  'descendants_count',  default: 0, null: false
      t.integer  'position'
      t.integer  'lft',                            null: false
      t.integer  'rgt',                            null: false
      t.datetime 'destroyed_at'
      t.timestamps null: false
    end
  end
end
