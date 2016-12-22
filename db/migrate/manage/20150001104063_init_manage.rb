class InitManage < ActiveRecord::Migration
  create_table "manage_editors", force: true do |t|
    t.integer "creator_id"
    t.string "name"
    t.integer "role_id"
    t.integer "company_id"
    t.datetime "destroyed_at"
    t.string "identifier"
    t.boolean "active", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "updater_id"
    t.integer "department_id"
    t.integer "supervisor_id"
    t.string "position"
    t.string "prefix"
  end

  create_table "manage_grants", force: true do |t|
    t.integer "editor_id"
    t.integer "role_id"
    t.integer "updater_id"
    t.boolean "active", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "creator_id"
  end

  add_index "manage_grants", ["active", "editor_id", "role_id"], name: "by_active_and_editor_id_and_role_id", using: :btree

  create_table "manage_logs", force: true do |t|
    t.integer "user_id"
    t.integer "controller"
    t.integer "action"
    t.integer "params_id"
    t.datetime "created_at"
  end

  create_table "manage_notifications", force: true do |t|
    t.integer "app_id"
    t.integer "user_id"
    t.integer "receiver_id"
    t.text "content"
    t.boolean "unread", default: true
    t.boolean "active", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manage_roles", force: true do |t|
    t.integer "creator_id"
    t.string "name"
    t.text "description"
    t.datetime "destroyed_at"
    t.integer "updater_id"
    t.boolean "active", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manage_users", force: true do |t|
    t.string "pic"
    t.string "name"
    t.string "gender"
    t.date "birthday"
    t.datetime "login_at"
    t.boolean "active", default: true, null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manage_users", ["birthday"], name: "index_manage_users_on_birthday", using: :btree
  add_index "manage_users", ["created_at"], name: "index_manage_users_on_created_at", using: :btree
  add_index "manage_users", ["id"], name: "index_manage_users_on_id", using: :btree
  add_index "manage_users", ["login_at"], name: "index_manage_users_on_login_at", using: :btree
  add_index "manage_users", ["updated_at"], name: "index_manage_users_on_updated_at", using: :btree
end
