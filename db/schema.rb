# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160106151821) do

  create_table "auction_products", force: :cascade do |t|
    t.integer  "user_id",                    limit: 4
    t.string   "name",                       limit: 255
    t.text     "description",                limit: 65535
    t.string   "pic",                        limit: 255
    t.decimal  "price",                                    precision: 10
    t.decimal  "discount",                                 precision: 10
    t.boolean  "published",                  limit: 1,                    default: false, null: false
    t.boolean  "active",                     limit: 1,                    default: true
    t.datetime "destroyed_at"
    t.datetime "arrived_at"
    t.datetime "updated_at"
    t.string   "cart_pic",                   limit: 255
    t.string   "spec_pic",                   limit: 255
    t.string   "color_pic",                  limit: 255
    t.string   "color_name",                 limit: 255
    t.string   "identifier",                 limit: 255
    t.string   "keywords",                   limit: 255
    t.string   "brand_link",                 limit: 255
    t.text     "brand_description",          limit: 65535
    t.text     "material",                   limit: 65535
    t.integer  "percent",                    limit: 4
    t.integer  "image_id",                   limit: 4
    t.integer  "market_id",                  limit: 4
    t.integer  "category_id",                limit: 4
    t.string   "relate_product_ids",         limit: 255
    t.boolean  "rec",                        limit: 1,                    default: false
    t.string   "rec_pic",                    limit: 255
    t.integer  "order",                      limit: 4,                    default: 1
    t.string   "percent_text",               limit: 255
    t.text     "accelerator",                limit: 65535
    t.string   "styles",                     limit: 255
    t.integer  "lock_version",               limit: 4,                    default: 0
    t.integer  "sell_duration",              limit: 4
    t.integer  "sell_total",                 limit: 4
    t.integer  "point",                      limit: 4,                    default: 0,     null: false
    t.integer  "video_id",                   limit: 4
    t.integer  "category1_id",               limit: 4
    t.integer  "category2_id",               limit: 4
    t.integer  "brand_id",                   limit: 4
    t.text     "attribute_data",             limit: 65535
    t.integer  "promotion_price",            limit: 4
    t.datetime "promotion_started_at"
    t.datetime "promotion_ended_at"
    t.datetime "published_at"
    t.string   "color",                      limit: 255
    t.string   "recommend",                  limit: 255
    t.string   "target",                     limit: 255
    t.string   "match_pic",                  limit: 255
    t.text     "match_product_ids",          limit: 65535
    t.string   "major_pic",                  limit: 255
    t.integer  "sold_count",                 limit: 4
    t.integer  "unsold_count",               limit: 4
    t.string   "measures_unsold_count",      limit: 255
    t.string   "remark",                     limit: 255
    t.string   "label",                      limit: 255
    t.string   "prefix",                     limit: 255
    t.text     "discount_history",           limit: 65535
    t.integer  "scarcity",                   limit: 4,                    default: 0,     null: false
    t.integer  "readings_count",             limit: 4,                    default: 0,     null: false
    t.text     "measure_table",              limit: 65535
    t.integer  "mall_id",                    limit: 4
    t.string   "fitting_pic",                limit: 255
    t.datetime "hourglass_started_at"
    t.integer  "hourglass_rate",             limit: 4
    t.integer  "hourglass_pause_duration",   limit: 4
    t.datetime "hourglass_trade_created_at"
    t.integer  "hourglass_trade_price",      limit: 4
    t.integer  "original_price",             limit: 4
    t.datetime "created_at"
    t.datetime "edited_at"
    t.string   "measure_description",        limit: 255
    t.integer  "zoom",                       limit: 4
    t.integer  "sell_current",               limit: 4
    t.string   "measure_style",              limit: 255
    t.string   "storage_location",           limit: 255
    t.text     "measure_suggestion",         limit: 65535
    t.integer  "items_count",                limit: 4
    t.integer  "items_unpublished_count",    limit: 4
    t.integer  "items_unsold_count",         limit: 4
    t.string   "origins",                    limit: 255
    t.string   "background",                 limit: 255
    t.text     "extra_description",          limit: 65535
    t.string   "extra_pic",                  limit: 255
    t.string   "model_pic",                  limit: 255
    t.integer  "minimum_price",              limit: 4
    t.string   "detail_pic",                 limit: 255
    t.integer  "category3_id",               limit: 4
    t.string   "download_pic",               limit: 255
    t.string   "thickness",                  limit: 255
    t.string   "elasticity",                 limit: 255
    t.string   "pliability",                 limit: 255
    t.integer  "multibuy_id",                limit: 4
    t.integer  "shop_price",                 limit: 4
  end

  add_index "auction_products", ["active", "id"], name: "by_active_and_id", using: :btree
  add_index "auction_products", ["active", "published", "brand_id", "published_at"], name: "by_active_and_published_and_brand_id_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "category1_id", "published_at"], name: "by_active_and_published_and_category1_id_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "category2_id", "published_at"], name: "by_active_and_published_and_category2_id_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "color", "published_at"], name: "by_active_and_published_and_color_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "mall_id", "target", "published_at"], name: "by_active_and_published_and_mall_id_and_target_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "price", "published_at"], name: "by_active_and_published_and_price_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "published_at"], name: "by_active_and_published_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "recommend", "published_at"], name: "by_active_and_published_and_recommend_and_published_at", using: :btree
  add_index "auction_products", ["active", "published", "target", "published_at"], name: "by_active_and_published_and_target_and_published_at", using: :btree
  add_index "auction_products", ["brand_id", "target", "unsold_count"], name: "by_brand_id_and_target_and_unsold_count", using: :btree

  create_table "cms_categories", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description",   limit: 65535
    t.string   "type",          limit: 255
    t.integer  "parent_id",     limit: 4
    t.integer  "pages_count",   limit: 4
    t.string   "url",           limit: 255
    t.integer  "lft",           limit: 4
    t.integer  "rgt",           limit: 4
    t.integer  "depth",         limit: 4
    t.boolean  "published",     limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        limit: 1,     default: true,        null: false
    t.integer  "lock_version",  limit: 4,     default: 0,           null: false
    t.integer  "position",      limit: 4
    t.string   "template_type", limit: 255,   default: "default"
    t.boolean  "is_page",       limit: 1,     default: false
    t.string   "page_tmpl",     limit: 255,   default: "full_page"
    t.text     "body",          limit: 65535
    t.text     "side_content",  limit: 65535
  end

  create_table "cms_pages", force: :cascade do |t|
    t.integer  "editor_id",     limit: 4
    t.string   "name",          limit: 255,   default: ""
    t.string   "template_type", limit: 255,   default: "full_page"
    t.string   "url",           limit: 255
    t.string   "background",    limit: 255
    t.integer  "position",      limit: 4
    t.text     "body",          limit: 65535
    t.boolean  "active",        limit: 1,     default: true,        null: false
    t.integer  "lock_version",  limit: 4,     default: 0,           null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "category_id",   limit: 4
    t.string   "pic_url",       limit: 255
    t.text     "summary",       limit: 65535
    t.text     "simplify",      limit: 65535
    t.text     "upload_keys",   limit: 65535
    t.boolean  "published",     limit: 1,     default: false
  end

  add_index "cms_pages", ["active", "url"], name: "index_cms_pages_on_active_and_url", using: :btree

  create_table "comment_images", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "comment_id",   limit: 4
    t.string   "pic",          limit: 255
    t.integer  "file_size",    limit: 4
    t.boolean  "active",       limit: 1,   default: true
    t.integer  "lock_version", limit: 4,   default: 0
    t.datetime "destroyed_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "comment_images", ["active", "comment_id"], name: "by_active_and_comment_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",           limit: 4,                     null: false
    t.integer  "editor_id",         limit: 4,                     null: false
    t.integer  "parent_id",         limit: 4
    t.integer  "commentable_id",    limit: 4,                     null: false
    t.string   "commentable_type",  limit: 255,                   null: false
    t.string   "title",             limit: 255,                   null: false
    t.text     "body",              limit: 65535,                 null: false
    t.string   "ip",                limit: 255
    t.boolean  "active",            limit: 1,     default: true,  null: false
    t.integer  "lock_version",      limit: 4,     default: 0,     null: false
    t.integer  "score",             limit: 4
    t.integer  "descendants_count", limit: 4,     default: 0,     null: false
    t.integer  "position",          limit: 4
    t.integer  "lft",               limit: 4,                     null: false
    t.integer  "rgt",               limit: 4,                     null: false
    t.datetime "destroyed_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.boolean  "published",         limit: 1,     default: false, null: false
  end

  create_table "core_accounts", force: :cascade do |t|
    t.string   "email",                            limit: 100
    t.string   "crypted_password",                 limit: 40
    t.string   "salt",                             limit: 40
    t.string   "remember_token",                   limit: 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",                  limit: 40
    t.datetime "activated_at"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.boolean  "active",                           limit: 1,   default: true
    t.datetime "destroyed_at"
    t.integer  "referrer_id",                      limit: 4
    t.string   "source",                           limit: 255
    t.string   "information",                      limit: 255
    t.integer  "link_id",                          limit: 4
    t.string   "phone",                            limit: 255
    t.datetime "phone_activated_at"
    t.string   "phone_activation_code",            limit: 255
    t.datetime "phone_activation_code_expired_at"
    t.string   "ip_address",                       limit: 255
    t.integer  "click_id",                         limit: 4
    t.string   "client",                           limit: 255
    t.integer  "shop_id",                          limit: 4
    t.integer  "guide_id",                         limit: 4
    t.integer  "latest_link_id",                   limit: 4
    t.integer  "latest_click_id",                  limit: 4
    t.date     "last_login_on"
  end

  add_index "core_accounts", ["active", "activated_at", "id"], name: "by_active_and_activated_at_and_id", using: :btree
  add_index "core_accounts", ["email"], name: "index_core_accounts_on_email", unique: true, using: :btree
  add_index "core_accounts", ["ip_address", "created_at"], name: "by_ip_address_and_created_at", using: :btree
  add_index "core_accounts", ["link_id"], name: "index_core_accounts_on_link_id", using: :btree
  add_index "core_accounts", ["phone"], name: "index_core_accounts_on_phone", using: :btree

  create_table "core_connections", force: :cascade do |t|
    t.integer  "account_id",    limit: 4
    t.string   "site",          limit: 255,                  null: false
    t.text     "token",         limit: 65535
    t.text     "secret",        limit: 65535
    t.text     "refresh_token", limit: 65535
    t.datetime "expired_at"
    t.text     "data",          limit: 65535
    t.boolean  "active",        limit: 1,     default: true, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "identifier",    limit: 255
    t.string   "email",         limit: 255
    t.string   "name",          limit: 255
    t.string   "sex",           limit: 255
    t.string   "pic",           limit: 255
    t.string   "phone",         limit: 255
  end

  add_index "core_connections", ["account_id", "site"], name: "by_account_id_and_site", using: :btree
  add_index "core_connections", ["active", "account_id"], name: "by_active_and_account_id", using: :btree
  add_index "core_connections", ["active", "site", "identifier"], name: "by_active_and_site_and_identifier", using: :btree

  create_table "core_infos", force: :cascade do |t|
    t.string   "im",                     limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "phone",                  limit: 255
    t.string   "website",                limit: 255
    t.text     "about",                  limit: 65535
    t.text     "interest",               limit: 65535
    t.text     "music",                  limit: 65535
    t.text     "movie",                  limit: 65535
    t.text     "tvshow",                 limit: 65535
    t.text     "game",                   limit: 65535
    t.text     "comic",                  limit: 65535
    t.text     "sport",                  limit: 65535
    t.text     "book",                   limit: 65535
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "hometown_id",            limit: 4
    t.integer  "location_id",            limit: 4
    t.string   "status",                 limit: 255
    t.integer  "gene_point",             limit: 4,     default: 0
    t.datetime "point_updated_at"
    t.boolean  "registration_completed", limit: 1
    t.integer  "point",                  limit: 4,     default: 0
    t.integer  "auction_point",          limit: 4,     default: 0
  end

  add_index "core_infos", ["created_at"], name: "index_core_infos_on_created_at", using: :btree
  add_index "core_infos", ["hometown_id"], name: "index_core_infos_on_hometown_id", using: :btree
  add_index "core_infos", ["id"], name: "index_core_infos_on_id", using: :btree
  add_index "core_infos", ["location_id"], name: "index_core_infos_on_location_id", using: :btree
  add_index "core_infos", ["updated_at"], name: "index_core_infos_on_updated_at", using: :btree

  create_table "core_infos_updatings", force: :cascade do |t|
    t.integer  "info_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "core_infos_updatings", ["created_at"], name: "index_core_infos_updatings_on_created_at", using: :btree
  add_index "core_infos_updatings", ["info_id"], name: "index_core_infos_updatings_on_info_id", using: :btree
  add_index "core_infos_updatings", ["updated_at"], name: "index_core_infos_updatings_on_updated_at", using: :btree

  create_table "core_logins", force: :cascade do |t|
    t.integer "user_id",    limit: 4
    t.date    "login_on"
    t.string  "ip_address", limit: 20
  end

  add_index "core_logins", ["user_id", "login_on"], name: "index_core_logins_on_user_id_and_login_on", using: :btree

  create_table "core_settings", force: :cascade do |t|
    t.string   "profile",                              limit: 255
    t.string   "friend",                               limit: 255
    t.string   "feed",                                 limit: 255
    t.string   "basic",                                limit: 255
    t.string   "personal",                             limit: 255
    t.string   "work",                                 limit: 255
    t.string   "im",                                   limit: 255
    t.string   "mobile",                               limit: 255
    t.string   "phone",                                limit: 255
    t.string   "website",                              limit: 255
    t.string   "email",                                limit: 255
    t.string   "search",                               limit: 255
    t.boolean  "my_profile_picture",                   limit: 1
    t.boolean  "my_friend_list",                       limit: 1
    t.boolean  "a_link_to_add_me_as_a_friend",         limit: 1
    t.boolean  "a_link_to_send_me_a_message",          limit: 1
    t.boolean  "search_engine_indexing",               limit: 1
    t.boolean  "sends_me_a_message",                   limit: 1
    t.boolean  "adds_me_as_a_friend",                  limit: 1
    t.boolean  "confirms_a_friendship_request",        limit: 1
    t.boolean  "suggests_a_friend_to_me",              limit: 1
    t.boolean  "adds_a_friend_i_suggested",            limit: 1
    t.boolean  "i_invited_joins_facebook",             limit: 1
    t.boolean  "has_a_birthday_coming_up",             limit: 1
    t.boolean  "pokes_me",                             limit: 1
    t.boolean  "posts_on_my_wall",                     limit: 1
    t.boolean  "comments_on_a_story_in_my_wall",       limit: 1
    t.boolean  "comments_after_me_on_a_wall_story",    limit: 1
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.string   "note",                                 limit: 255
    t.string   "photo",                                limit: 255
    t.string   "share",                                limit: 255
    t.boolean  "public_search",                        limit: 1,   default: true
    t.boolean  "public_online_status",                 limit: 1
    t.boolean  "receive_promotion_email",              limit: 1
    t.boolean  "receive_promotion_email_of_event",     limit: 1,   default: true
    t.boolean  "receive_promotion_email_of_voucher",   limit: 1,   default: true
    t.boolean  "receive_promotion_email_of_news",      limit: 1,   default: true
    t.boolean  "receive_promotion_email_of_recommend", limit: 1,   default: true
    t.boolean  "receive_promotion_sms_of_event",       limit: 1,   default: true
    t.boolean  "receive_promotion_sms_of_voucher",     limit: 1,   default: true
    t.boolean  "receive_promotion_sms_of_promote",     limit: 1,   default: true
  end

  add_index "core_settings", ["a_link_to_add_me_as_a_friend"], name: "index_core_settings_on_a_link_to_add_me_as_a_friend", using: :btree
  add_index "core_settings", ["a_link_to_send_me_a_message"], name: "index_core_settings_on_a_link_to_send_me_a_message", using: :btree
  add_index "core_settings", ["adds_a_friend_i_suggested"], name: "index_core_settings_on_adds_a_friend_i_suggested", using: :btree
  add_index "core_settings", ["adds_me_as_a_friend"], name: "index_core_settings_on_adds_me_as_a_friend", using: :btree
  add_index "core_settings", ["comments_after_me_on_a_wall_story"], name: "index_core_settings_on_comments_after_me_on_a_wall_story", using: :btree
  add_index "core_settings", ["comments_on_a_story_in_my_wall"], name: "index_core_settings_on_comments_on_a_story_in_my_wall", using: :btree
  add_index "core_settings", ["confirms_a_friendship_request"], name: "index_core_settings_on_confirms_a_friendship_request", using: :btree
  add_index "core_settings", ["created_at"], name: "index_core_settings_on_created_at", using: :btree
  add_index "core_settings", ["has_a_birthday_coming_up"], name: "index_core_settings_on_has_a_birthday_coming_up", using: :btree
  add_index "core_settings", ["i_invited_joins_facebook"], name: "index_core_settings_on_i_invited_joins_facebook", using: :btree
  add_index "core_settings", ["id"], name: "index_core_settings_on_id", using: :btree
  add_index "core_settings", ["my_friend_list"], name: "index_core_settings_on_my_friend_list", using: :btree
  add_index "core_settings", ["my_profile_picture"], name: "index_core_settings_on_my_profile_picture", using: :btree
  add_index "core_settings", ["pokes_me"], name: "index_core_settings_on_pokes_me", using: :btree
  add_index "core_settings", ["posts_on_my_wall"], name: "index_core_settings_on_posts_on_my_wall", using: :btree
  add_index "core_settings", ["search_engine_indexing"], name: "index_core_settings_on_search_engine_indexing", using: :btree
  add_index "core_settings", ["sends_me_a_message"], name: "index_core_settings_on_sends_me_a_message", using: :btree
  add_index "core_settings", ["suggests_a_friend_to_me"], name: "index_core_settings_on_suggests_a_friend_to_me", using: :btree
  add_index "core_settings", ["updated_at"], name: "index_core_settings_on_updated_at", using: :btree

  create_table "core_settings_updatings", force: :cascade do |t|
    t.integer  "setting_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "core_settings_updatings", ["created_at"], name: "index_core_settings_updatings_on_created_at", using: :btree
  add_index "core_settings_updatings", ["setting_id"], name: "index_core_settings_updatings_on_setting_id", using: :btree
  add_index "core_settings_updatings", ["updated_at"], name: "index_core_settings_updatings_on_updated_at", using: :btree

  create_table "core_trades", force: :cascade do |t|
    t.integer  "app_id",      limit: 4
    t.string   "name",        limit: 40
    t.text     "description", limit: 65535
    t.string   "icon",        limit: 255
    t.integer  "point",       limit: 4
    t.integer  "quota",       limit: 4
    t.integer  "limit",       limit: 4
    t.string   "period",      limit: 20
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "core_trades", ["created_at"], name: "index_core_trades_on_created_at", using: :btree
  add_index "core_trades", ["id"], name: "index_core_trades_on_id", using: :btree
  add_index "core_trades", ["updated_at"], name: "index_core_trades_on_updated_at", using: :btree

  create_table "core_transactions", force: :cascade do |t|
    t.integer  "user_id",       limit: 4
    t.integer  "point",         limit: 4
    t.integer  "gene_point",    limit: 4
    t.integer  "auction_point", limit: 4
    t.integer  "incremented",   limit: 4
    t.text     "description",   limit: 65535
    t.boolean  "active",        limit: 1,     default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "editor_id",     limit: 4
  end

  create_table "core_users", force: :cascade do |t|
    t.string   "pic",          limit: 255
    t.string   "name",         limit: 20
    t.string   "sex",          limit: 20
    t.date     "birthday"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "abbrs",        limit: 255
    t.integer  "photo_id",     limit: 4
    t.integer  "invite_count", limit: 4
    t.boolean  "active",       limit: 1,   default: true, null: false
  end

  add_index "core_users", ["birthday"], name: "index_core_users_on_birthday", using: :btree
  add_index "core_users", ["created_at"], name: "index_core_users_on_created_at", using: :btree
  add_index "core_users", ["id"], name: "index_core_users_on_id", using: :btree
  add_index "core_users", ["updated_at"], name: "index_core_users_on_updated_at", using: :btree

  create_table "core_users_readings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "duration",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "core_users_readings", ["created_at"], name: "index_core_users_readings_on_created_at", using: :btree
  add_index "core_users_readings", ["updated_at"], name: "index_core_users_readings_on_updated_at", using: :btree
  add_index "core_users_readings", ["user_id"], name: "index_core_users_readings_on_user_id", using: :btree

  create_table "core_users_updatings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "custom_page_page_images", force: :cascade do |t|
    t.integer  "page_id",          limit: 4
    t.string   "pic",              limit: 255
    t.string   "pic_file_name",    limit: 255
    t.integer  "pic_file_size",    limit: 4
    t.string   "pic_content_type", limit: 255
    t.datetime "pic_updated_at"
    t.integer  "pic_image_width",  limit: 4
    t.integer  "pic_image_height", limit: 4
    t.boolean  "active",           limit: 1,   default: true, null: false
    t.integer  "lock_version",     limit: 4,   default: 0,    null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "custom_page_page_images", ["active", "page_id"], name: "index_custom_page_pages_images_on_active_and_page_id", using: :btree

  create_table "custom_page_pages", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "position",              limit: 255
    t.string   "engine",                limit: 255
    t.text     "content",               limit: 65535
    t.integer  "editor_id",             limit: 4
    t.boolean  "published",             limit: 1,     default: false, null: false
    t.boolean  "active",                limit: 1,     default: true,  null: false
    t.integer  "lock_version",          limit: 4,     default: 0,     null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "title",                 limit: 255
    t.string   "series",                limit: 255
    t.string   "snapshot",              limit: 255
    t.string   "snapshot_file_name",    limit: 255
    t.integer  "snapshot_file_size",    limit: 4
    t.string   "snapshot_content_type", limit: 255
    t.datetime "snapshot_updated_at"
    t.integer  "snapshot_image_width",  limit: 4
    t.integer  "snapshot_image_height", limit: 4
    t.string   "keywords",              limit: 255
    t.string   "description",           limit: 255
    t.boolean  "template",              limit: 1,     default: false
  end

  add_index "custom_page_pages", ["active", "id"], name: "by_active_and_id", using: :btree
  add_index "custom_page_pages", ["active", "published", "position", "id"], name: "by_active_and_published_and_position_and_id", using: :btree

  create_table "custom_page_pages_pages", force: :cascade do |t|
    t.integer  "page_id",      limit: 4
    t.integer  "child_id",     limit: 4
    t.boolean  "active",       limit: 1, default: true, null: false
    t.integer  "lock_version", limit: 4, default: 0,    null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "custom_page_pages_pages", ["active", "page_id", "child_id"], name: "by_active_and_page_id_and_child_id", using: :btree

  create_table "data_cities", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "province_id",  limit: 4
    t.integer  "user_id",      limit: 4
    t.boolean  "active",       limit: 1,   default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "order",        limit: 4,   default: 1
    t.integer  "lock_version", limit: 4,   default: 0
    t.boolean  "published",    limit: 1,   default: false, null: false
  end

  add_index "data_cities", ["active", "id"], name: "by_active_and_id", using: :btree
  add_index "data_cities", ["province_id"], name: "index_cities_on_province_id", using: :btree

  create_table "data_countries", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "user_id",      limit: 4
    t.boolean  "active",       limit: 1,   default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "order",        limit: 4,   default: 1
    t.integer  "lock_version", limit: 4,   default: 0
    t.boolean  "published",    limit: 1,   default: false, null: false
  end

  add_index "data_countries", ["active", "id"], name: "by_active_and_id", using: :btree

  create_table "data_provinces", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "country_id",   limit: 4
    t.integer  "user_id",      limit: 4
    t.boolean  "active",       limit: 1,   default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "order",        limit: 4,   default: 1
    t.integer  "lock_version", limit: 4,   default: 0
    t.boolean  "published",    limit: 1,   default: false, null: false
  end

  add_index "data_provinces", ["active", "id"], name: "by_active_and_id", using: :btree

  create_table "data_towns", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "city_id",      limit: 4
    t.integer  "user_id",      limit: 4
    t.boolean  "active",       limit: 1,   default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "order",        limit: 4,   default: 1
    t.integer  "lock_version", limit: 4,   default: 0
    t.boolean  "published",    limit: 1,   default: false, null: false
  end

  add_index "data_towns", ["active", "id"], name: "by_active_and_id", using: :btree
  add_index "data_towns", ["city_id"], name: "index_data_towns_on_city_id", using: :btree

  create_table "manage_editors", force: :cascade do |t|
    t.integer  "creator_id",    limit: 4
    t.string   "name",          limit: 255
    t.integer  "role_id",       limit: 4
    t.integer  "company_id",    limit: 4
    t.datetime "destroyed_at"
    t.string   "identifier",    limit: 255
    t.boolean  "active",        limit: 1,   default: true, null: false
    t.integer  "lock_version",  limit: 4,   default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "updater_id",    limit: 4
    t.integer  "department_id", limit: 4
    t.integer  "supervisor_id", limit: 4
    t.string   "position",      limit: 255
    t.string   "prefix",        limit: 255
  end

  create_table "manage_grants", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.integer  "role_id",      limit: 4
    t.integer  "updater_id",   limit: 4
    t.boolean  "active",       limit: 1, default: true, null: false
    t.integer  "lock_version", limit: 4, default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id",   limit: 4
  end

  add_index "manage_grants", ["active", "editor_id", "role_id"], name: "by_active_and_editor_id_and_role_id", using: :btree

  create_table "manage_logs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "controller", limit: 4
    t.integer  "action",     limit: 4
    t.integer  "params_id",  limit: 4
    t.datetime "created_at"
  end

  create_table "manage_notifications", force: :cascade do |t|
    t.integer  "app_id",       limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "receiver_id",  limit: 4
    t.text     "content",      limit: 65535
    t.boolean  "unread",       limit: 1,     default: true
    t.boolean  "active",       limit: 1,     default: true, null: false
    t.integer  "lock_version", limit: 4,     default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manage_roles", force: :cascade do |t|
    t.integer  "creator_id",       limit: 4
    t.string   "name",             limit: 255
    t.text     "description",      limit: 65535
    t.datetime "destroyed_at"
    t.integer  "updater_id",       limit: 4
    t.boolean  "active",           limit: 1,     default: true, null: false
    t.integer  "lock_version",     limit: 4,     default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_product",     limit: 4,     default: 0
    t.integer  "shop_attribute",   limit: 4,     default: 0
    t.integer  "shop_item",        limit: 4,     default: 0
    t.integer  "shop_trade",       limit: 4,     default: 0
    t.integer  "shop_category",    limit: 4,     default: 0
    t.integer  "shop_coupon",      limit: 4,     default: 0
    t.integer  "shop_contact",     limit: 4,     default: 0
    t.integer  "shop_brand",       limit: 4,     default: 0
    t.integer  "shop_event",       limit: 4,     default: 0
    t.integer  "shop_level",       limit: 4,     default: 0
    t.integer  "shop_mail",        limit: 4,     default: 0
    t.integer  "custom_page_page", limit: 4,     default: 0
    t.integer  "shop_sms",         limit: 4,     default: 0
    t.integer  "shop_user",        limit: 4,     default: 0
    t.integer  "shop_voucher",     limit: 4,     default: 0
    t.integer  "shop_preference",  limit: 4,     default: 0
    t.integer  "cms_category",     limit: 4,     default: 0
    t.integer  "cms_page",         limit: 4,     default: 0
    t.integer  "core_user",        limit: 4,     default: 0
    t.integer  "core_account",     limit: 4,     default: 0
    t.integer  "core_comment",     limit: 4,     default: 0
    t.integer  "core_transaction", limit: 4,     default: 0
    t.integer  "manage_grant",     limit: 4,     default: 0
    t.integer  "manage_editor",    limit: 4,     default: 0
    t.integer  "manage_role",      limit: 4,     default: 0
    t.integer  "manage_user",      limit: 4,     default: 0
    t.integer  "manage_log",       limit: 4,     default: 0
    t.integer  "shop_comment",     limit: 4,     default: 0
    t.integer  "shop_unit",        limit: 4,     default: 0
  end

  create_table "manage_users", force: :cascade do |t|
    t.string   "pic",          limit: 255
    t.string   "name",         limit: 255
    t.string   "gender",       limit: 255
    t.date     "birthday"
    t.datetime "login_at"
    t.boolean  "active",       limit: 1,   default: true, null: false
    t.integer  "lock_version", limit: 4,   default: 0,    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "manage_users", ["birthday"], name: "index_manage_users_on_birthday", using: :btree
  add_index "manage_users", ["created_at"], name: "index_manage_users_on_created_at", using: :btree
  add_index "manage_users", ["id"], name: "index_manage_users_on_id", using: :btree
  add_index "manage_users", ["login_at"], name: "index_manage_users_on_login_at", using: :btree
  add_index "manage_users", ["updated_at"], name: "index_manage_users_on_updated_at", using: :btree

  create_table "shop_attributes", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.string   "name",         limit: 255
    t.text     "option_list",  limit: 65535
    t.boolean  "searchable",   limit: 1,     default: false, null: false
    t.boolean  "active",       limit: 1,     default: true,  null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "lock_version", limit: 4,     default: 0
  end

  add_index "shop_attributes", ["active", "id"], name: "by_active_and_id", using: :btree

  create_table "shop_brand_images", force: :cascade do |t|
    t.string   "pic",              limit: 255
    t.string   "pic_file_name",    limit: 255
    t.integer  "pic_file_size",    limit: 4
    t.string   "pic_content_type", limit: 255
    t.datetime "pic_updated_at"
    t.integer  "pic_image_width",  limit: 4
    t.integer  "pic_image_height", limit: 4
    t.integer  "sequence",         limit: 4
    t.integer  "brand_id",         limit: 4
    t.boolean  "active",           limit: 1,   default: true, null: false
    t.integer  "lock_version",     limit: 4,   default: 0,    null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "shop_brands", force: :cascade do |t|
    t.integer  "editor_id",           limit: 4
    t.string   "name",                limit: 255
    t.string   "chinese",             limit: 255
    t.string   "abbreviation",        limit: 255
    t.string   "pic",                 limit: 255
    t.string   "website",             limit: 255
    t.text     "description",         limit: 65535
    t.integer  "order",               limit: 4,     default: 1
    t.string   "recommend",           limit: 255
    t.boolean  "published",           limit: 1,     default: false, null: false
    t.boolean  "active",              limit: 1,     default: true,  null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "link",                limit: 255
    t.string   "initial",             limit: 255
    t.string   "swf",                 limit: 255
    t.string   "swf2",                limit: 255
    t.integer  "lock_version",        limit: 4,     default: 0
    t.string   "title",               limit: 255
    t.string   "pronunciation",       limit: 255
    t.integer  "country_id",          limit: 4
    t.datetime "founded_on"
    t.string   "keywords",            limit: 255
    t.string   "special_product_ids", limit: 255
    t.boolean  "introduced",          limit: 1
    t.integer  "year",                limit: 4
    t.string   "shop_link",           limit: 255
    t.string   "genre",               limit: 255
    t.string   "material",            limit: 255
    t.text     "summary",             limit: 65535
  end

  create_table "shop_cards", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "number",       limit: 255
    t.string   "password",     limit: 255
    t.integer  "value",        limit: 4
    t.integer  "balance",      limit: 4
    t.integer  "price",        limit: 4
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "user_id",      limit: 4
    t.text     "remark",       limit: 65535
    t.integer  "editor_id",    limit: 4
    t.boolean  "published",    limit: 1,     default: false, null: false
    t.boolean  "active",       limit: 1,     default: true,  null: false
    t.integer  "lock_version", limit: 4,     default: 0,     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "shop_cards", ["active", "published", "user_id", "started_at", "ended_at", "balance"], name: "by_active_and_published_and_user_id_and_started_at_and_balance", using: :btree

  create_table "shop_categories", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "name",                limit: 255
    t.text     "measures",            limit: 65535
    t.boolean  "active",              limit: 1,     default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "lock_version",        limit: 4,     default: 0
    t.integer  "parent_id",           limit: 4
    t.text     "description",         limit: 65535
    t.string   "ranges",              limit: 255
    t.integer  "order",               limit: 4,     default: 1
    t.boolean  "published",           limit: 1,     default: false, null: false
    t.string   "attribute_ids",       limit: 255
    t.boolean  "female",              limit: 1,     default: false, null: false
    t.boolean  "male",                limit: 1,     default: false, null: false
    t.string   "measure_properties",  limit: 255
    t.string   "measure_pic",         limit: 255
    t.integer  "bust_offset",         limit: 4
    t.integer  "bust_error",          limit: 4
    t.integer  "waistline_offset",    limit: 4
    t.integer  "waistline_error",     limit: 4
    t.integer  "hip_offset",          limit: 4
    t.integer  "hip_error",           limit: 4
    t.integer  "shoulder_offset",     limit: 4
    t.integer  "shoulder_error",      limit: 4
    t.integer  "arm_offset",          limit: 4
    t.integer  "arm_error",           limit: 4
    t.integer  "leg_offset",          limit: 4
    t.integer  "leg_error",           limit: 4
    t.string   "priority",            limit: 255
    t.string   "contrast_pic",        limit: 255
    t.string   "pic",                 limit: 255
    t.string   "pic_file_name",       limit: 255
    t.string   "pic_content_type",    limit: 255
    t.integer  "pic_file_size",       limit: 4
    t.datetime "pic_updated_at"
    t.integer  "pic_image_width",     limit: 4
    t.integer  "pic_image_height",    limit: 4
    t.integer  "lft",                 limit: 4
    t.integer  "rgt",                 limit: 4
    t.integer  "depth",               limit: 4
    t.integer  "position",            limit: 4
    t.string   "basic_attribute_ids", limit: 255
    t.string   "banner_pic",          limit: 255
    t.string   "banner_pic_link",     limit: 255
  end

  create_table "shop_contacts", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.string   "name",             limit: 255
    t.string   "country",          limit: 255
    t.string   "province",         limit: 255
    t.string   "city",             limit: 255
    t.string   "town",             limit: 255
    t.string   "address",          limit: 255
    t.string   "postcode",         limit: 255
    t.string   "phone",            limit: 255
    t.string   "mobile",           limit: 255
    t.boolean  "active",           limit: 1,     default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "lock_version",     limit: 4,     default: 0
    t.integer  "editor_id",        limit: 4
    t.string   "delivery_service", limit: 255
    t.text     "remark",           limit: 65535
  end

  create_table "shop_coupons", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.string   "code",         limit: 255
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "limitation",   limit: 4
    t.string   "function",     limit: 255
    t.integer  "point",        limit: 4
    t.boolean  "published",    limit: 1,     default: false, null: false
    t.boolean  "active",       limit: 1,     default: true,  null: false
    t.integer  "lock_version", limit: 4,     default: 0,     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "event_id",     limit: 4
    t.string   "event_ids",    limit: 255
  end

  add_index "shop_coupons", ["active", "published", "code"], name: "by_active_and_published_and_code", using: :btree

  create_table "shop_events", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
    t.integer  "amount",       limit: 4
    t.integer  "limitation",   limit: 4
    t.datetime "started_at"
    t.datetime "ended_at"
    t.boolean  "active",       limit: 1,     default: true,  null: false
    t.integer  "lock_version", limit: 4,     default: 0,     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "price",        limit: 4
    t.boolean  "published",    limit: 1,     default: false, null: false
    t.string   "genre",        limit: 255
  end

  create_table "shop_favorites", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "product_id",   limit: 4
    t.boolean  "active",       limit: 1, default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "lock_version", limit: 4, default: 0
  end

  add_index "shop_favorites", ["user_id", "product_id"], name: "by_user_id_and_product_id", using: :btree

  create_table "shop_images", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "product_id",   limit: 4
    t.string   "large",        limit: 255
    t.string   "medium",       limit: 255
    t.string   "small",        limit: 255
    t.boolean  "active",       limit: 1,     default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "lock_version", limit: 4,     default: 0
    t.text     "description",  limit: 65535
    t.string   "full",         limit: 255
    t.integer  "sequence",     limit: 4
  end

  add_index "shop_images", ["active", "product_id"], name: "by_active_and_product_id", using: :btree

  create_table "shop_items", force: :cascade do |t|
    t.integer  "user_id",          limit: 4
    t.integer  "product_id",       limit: 4
    t.boolean  "active",           limit: 1,                           default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.string   "measure",          limit: 255
    t.string   "identifer",        limit: 255
    t.integer  "trade_id",         limit: 4
    t.integer  "lock_version",     limit: 4,                           default: 0
    t.boolean  "published",        limit: 1,                           default: false, null: false
    t.string   "remark",           limit: 255
    t.string   "original_measure", limit: 255
    t.integer  "purchase_type",    limit: 4
    t.datetime "storage_at"
    t.datetime "expired_at"
    t.string   "factory_measure",  limit: 255
    t.string   "standard_measure", limit: 255
    t.string   "origin",           limit: 255
    t.string   "storage_name",     limit: 255
    t.string   "store_num",        limit: 255
    t.decimal  "cost_price",                   precision: 8, scale: 2, default: 0.0
    t.string   "barcode",          limit: 255
  end

  add_index "shop_items", ["active", "id"], name: "by_active_and_id", using: :btree
  add_index "shop_items", ["active", "product_id"], name: "index_shop_items_on_active_and_product_id", using: :btree
  add_index "shop_items", ["active", "published", "product_id", "measure"], name: "by_active_and_published_and_product_id_and_measure", using: :btree
  add_index "shop_items", ["identifer"], name: "index_shop_items_on_identifer", using: :btree

  create_table "shop_items_updatings", force: :cascade do |t|
    t.integer  "item_id",      limit: 4
    t.integer  "editor_id",    limit: 4
    t.boolean  "published",    limit: 1
    t.integer  "lock_version", limit: 4, default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "shop_items_updatings", ["item_id", "created_at"], name: "by_item_id_and_created_at", using: :btree

  create_table "shop_levels", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.string   "name",         limit: 255
    t.text     "description",  limit: 65535
    t.string   "icon",         limit: 255
    t.integer  "limitation",   limit: 4
    t.integer  "percent",      limit: 4
    t.string   "mall_ids",     limit: 255
    t.boolean  "active",       limit: 1,     default: true, null: false
    t.integer  "lock_version", limit: 4,     default: 0,    null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "reservation",  limit: 4
  end

  create_table "shop_products", force: :cascade do |t|
    t.integer  "user_id",                    limit: 4
    t.string   "name",                       limit: 255
    t.text     "description",                limit: 65535
    t.string   "pic",                        limit: 255
    t.decimal  "price",                                    precision: 10
    t.decimal  "discount",                                 precision: 10
    t.boolean  "published",                  limit: 1,                    default: false, null: false
    t.boolean  "active",                     limit: 1,                    default: true
    t.datetime "destroyed_at"
    t.datetime "arrived_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.string   "cart_pic",                   limit: 255
    t.string   "spec_pic",                   limit: 255
    t.string   "color_pic",                  limit: 255
    t.string   "color_name",                 limit: 255
    t.string   "identifier",                 limit: 255
    t.string   "keywords",                   limit: 255
    t.string   "brand_link",                 limit: 255
    t.text     "brand_description",          limit: 65535
    t.text     "material",                   limit: 65535
    t.integer  "percent",                    limit: 4
    t.integer  "image_id",                   limit: 4
    t.integer  "market_id",                  limit: 4
    t.integer  "category_id",                limit: 4
    t.string   "relate_product_ids",         limit: 255
    t.boolean  "rec",                        limit: 1,                    default: false
    t.string   "rec_pic",                    limit: 255
    t.integer  "order",                      limit: 4,                    default: 1
    t.string   "percent_text",               limit: 255
    t.text     "accelerator",                limit: 65535
    t.string   "styles",                     limit: 255
    t.integer  "lock_version",               limit: 4,                    default: 0
    t.integer  "sell_duration",              limit: 4
    t.integer  "sell_total",                 limit: 4
    t.integer  "point",                      limit: 4,                    default: 0,     null: false
    t.integer  "video_id",                   limit: 4
    t.integer  "category1_id",               limit: 4
    t.integer  "category2_id",               limit: 4
    t.integer  "brand_id",                   limit: 4
    t.text     "attribute_data",             limit: 65535
    t.integer  "promotion_price",            limit: 4
    t.datetime "promotion_started_at"
    t.datetime "promotion_ended_at"
    t.datetime "published_at"
    t.string   "color",                      limit: 255
    t.string   "recommend",                  limit: 255
    t.string   "target",                     limit: 255
    t.string   "match_pic",                  limit: 255
    t.text     "match_product_ids",          limit: 65535
    t.string   "major_pic",                  limit: 255
    t.integer  "sold_count",                 limit: 4
    t.integer  "unsold_count",               limit: 4
    t.string   "measures_unsold_count",      limit: 255
    t.string   "remark",                     limit: 255
    t.string   "label",                      limit: 255
    t.string   "prefix",                     limit: 255
    t.text     "discount_history",           limit: 65535
    t.integer  "scarcity",                   limit: 4,                    default: 0,     null: false
    t.integer  "readings_count",             limit: 4,                    default: 0,     null: false
    t.text     "measure_table",              limit: 65535
    t.integer  "mall_id",                    limit: 4
    t.string   "fitting_pic",                limit: 255
    t.datetime "hourglass_started_at"
    t.integer  "hourglass_rate",             limit: 4
    t.integer  "hourglass_pause_duration",   limit: 4
    t.datetime "hourglass_trade_created_at"
    t.integer  "hourglass_trade_price",      limit: 4
    t.integer  "original_price",             limit: 4
    t.datetime "created_at"
    t.datetime "edited_at"
    t.string   "measure_description",        limit: 255
    t.integer  "zoom",                       limit: 4
    t.integer  "sell_current",               limit: 4
    t.string   "measure_style",              limit: 255
    t.string   "storage_location",           limit: 255
    t.text     "measure_suggestion",         limit: 65535
    t.integer  "items_count",                limit: 4
    t.integer  "items_unpublished_count",    limit: 4
    t.integer  "items_unsold_count",         limit: 4
    t.string   "origins",                    limit: 255
    t.string   "background",                 limit: 255
    t.text     "extra_description",          limit: 65535
    t.string   "extra_pic",                  limit: 255
    t.string   "model_pic",                  limit: 255
    t.integer  "minimum_price",              limit: 4
    t.string   "detail_pic",                 limit: 255
    t.integer  "category3_id",               limit: 4
    t.string   "download_pic",               limit: 255
    t.string   "thickness",                  limit: 255
    t.string   "elasticity",                 limit: 255
    t.string   "pliability",                 limit: 255
    t.integer  "multibuy_id",                limit: 4
    t.integer  "shop_price",                 limit: 4
    t.string   "list_pic",                   limit: 255
    t.text     "body",                       limit: 65535
  end

  add_index "shop_products", ["active", "id"], name: "by_active_and_id", using: :btree
  add_index "shop_products", ["active", "published", "brand_id", "published_at"], name: "by_active_and_published_and_brand_id_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "category1_id", "published_at"], name: "by_active_and_published_and_category1_id_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "category2_id", "published_at"], name: "by_active_and_published_and_category2_id_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "color", "published_at"], name: "by_active_and_published_and_color_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "mall_id", "target", "published_at"], name: "by_active_and_published_and_mall_id_and_target_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "price", "published_at"], name: "by_active_and_published_and_price_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "published_at"], name: "by_active_and_published_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "recommend", "published_at"], name: "by_active_and_published_and_recommend_and_published_at", using: :btree
  add_index "shop_products", ["active", "published", "target", "published_at"], name: "by_active_and_published_and_target_and_published_at", using: :btree
  add_index "shop_products", ["brand_id", "target", "unsold_count"], name: "by_brand_id_and_target_and_unsold_count", using: :btree

  create_table "shop_products_updatings", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "editor_id",  limit: 4
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "published",  limit: 1
  end

  add_index "shop_products_updatings", ["product_id", "created_at"], name: "by_product_id_and_created_at", using: :btree

  create_table "shop_smss", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.integer  "trade_id",     limit: 4
    t.integer  "costumer_id",  limit: 4
    t.string   "phone",        limit: 255
    t.text     "content",      limit: 65535
    t.text     "remark",       limit: 65535
    t.boolean  "active",       limit: 1,     default: true,  null: false
    t.boolean  "success",      limit: 1,     default: false, null: false
    t.integer  "lock_version", limit: 4,     default: 0,     null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "send_at"
    t.integer  "user_id",      limit: 4
  end

  add_index "shop_smss", ["active", "trade_id"], name: "index_shop_smss_on_active_and_trade_id", using: :btree

  create_table "shop_synonyms", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.string   "name",         limit: 255
    t.integer  "brand_id",     limit: 4
    t.integer  "category1_id", limit: 4
    t.integer  "category2_id", limit: 4
    t.string   "target",       limit: 255
    t.string   "color",        limit: 255
    t.boolean  "active",       limit: 1,   default: true, null: false
    t.boolean  "published",    limit: 1
    t.integer  "lock_version", limit: 4,   default: 0,    null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "shop_synonyms", ["active", "published", "name"], name: "by_active_and_published_and_name", using: :btree

  create_table "shop_trades", force: :cascade do |t|
    t.integer  "user_id",                     limit: 4
    t.integer  "contact_id",                  limit: 4
    t.string   "status",                      limit: 255
    t.text     "comment",                     limit: 65535
    t.decimal  "price",                                     precision: 10
    t.boolean  "active",                      limit: 1,                    default: true
    t.datetime "destroyed_at"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "item_id",                     limit: 4
    t.string   "identifier",                  limit: 255
    t.integer  "percent",                     limit: 4
    t.string   "payment_service",             limit: 255
    t.string   "payment_identifier",          limit: 255
    t.string   "delivery_service",            limit: 255
    t.string   "delivery_identifier",         limit: 255
    t.text     "remark",                      limit: 65535
    t.integer  "lock_version",                limit: 4,                    default: 0
    t.integer  "link_id",                     limit: 4
    t.string   "delivery_time",               limit: 255
    t.string   "invoice_type",                limit: 255
    t.string   "invoice_title",               limit: 255
    t.string   "invoice_content",             limit: 255
    t.integer  "click_id",                    limit: 4
    t.integer  "invoice_contact_id",          limit: 4
    t.boolean  "receipted",                   limit: 1,                    default: false, null: false
    t.datetime "receipted_at"
    t.string   "delivery_phone",              limit: 255
    t.integer  "editor_id",                   limit: 4
    t.integer  "audit_editor_id",             limit: 4
    t.datetime "audit_at"
    t.integer  "ship_editor_id",              limit: 4
    t.datetime "ship_at"
    t.integer  "freeze_editor_id",            limit: 4
    t.datetime "freeze_at"
    t.integer  "receipt_editor_id",           limit: 4
    t.integer  "prepare_editor_id",           limit: 4
    t.datetime "prepare_at"
    t.integer  "original_id",                 limit: 4
    t.string   "invoice_delivery_service",    limit: 255
    t.string   "invoice_delivery_identifier", limit: 255
    t.text     "invoice_remark",              limit: 65535
    t.datetime "delivery_received_at"
    t.string   "checkout_token",              limit: 255
    t.string   "checkout_comment",            limit: 255
    t.string   "checkout_name",               limit: 255
    t.integer  "delivery_receipted_amount",   limit: 4
    t.datetime "delivery_receipted_at"
    t.datetime "delivery_remitted_at"
    t.integer  "delivery_settled_amount",     limit: 4
    t.datetime "delivery_settled_at"
    t.datetime "delivery_reconciled_at"
    t.string   "client",                      limit: 255
    t.integer  "payment_price",               limit: 4
    t.integer  "shop_id",                     limit: 4
    t.string   "shop_identifier",             limit: 255
    t.text     "payment_return",              limit: 65535
    t.integer  "latest_link_id",              limit: 4
    t.integer  "latest_click_id",             limit: 4
    t.integer  "out_editor_id",               limit: 4
    t.datetime "out_at"
    t.boolean  "is_present",                  limit: 1,                    default: false, null: false
    t.integer  "point",                       limit: 4
    t.integer  "punishment",                  limit: 4
  end

  create_table "shop_units", force: :cascade do |t|
    t.integer  "trade_id",                 limit: 4
    t.integer  "item_id",                  limit: 4
    t.integer  "discount",                 limit: 4
    t.integer  "price",                    limit: 4
    t.integer  "percent",                  limit: 4
    t.integer  "point",                    limit: 4
    t.boolean  "returned",                 limit: 1,     default: false, null: false
    t.boolean  "active",                   limit: 1,     default: true,  null: false
    t.integer  "lock_version",             limit: 4,     default: 0
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "status",                   limit: 255
    t.integer  "return_editor_id",         limit: 4
    t.datetime "returned_at"
    t.text     "remark",                   limit: 65535
    t.string   "return_phone",             limit: 255
    t.string   "return_name",              limit: 255
    t.string   "return_bank",              limit: 255
    t.string   "return_account",           limit: 255
    t.datetime "request_at"
    t.datetime "audit_at"
    t.datetime "receive_at"
    t.integer  "audit_editor_id",          limit: 4
    t.integer  "receive_editor_id",        limit: 4
    t.datetime "freeze_at"
    t.integer  "freeze_editor_id",         limit: 4
    t.string   "return_branch",            limit: 255
    t.string   "return_province",          limit: 255
    t.string   "return_city",              limit: 255
    t.integer  "editor_id",                limit: 4
    t.integer  "request_editor_id",        limit: 4
    t.integer  "transfer_editor_id",       limit: 4
    t.datetime "transfer_at"
    t.boolean  "prepared",                 limit: 1,     default: false, null: false
    t.text     "prepare_remark",           limit: 65535
    t.integer  "voucher_id",               limit: 4
    t.integer  "amount_received",          limit: 4
    t.integer  "amount_returned",          limit: 4
    t.integer  "amount_receive_editor_id", limit: 4
    t.datetime "amount_received_at"
    t.string   "return_reason",            limit: 255
    t.datetime "amount_returned_at"
    t.integer  "amount_return_editor_id",  limit: 4
    t.integer  "amount_balance_returned",  limit: 4
    t.integer  "guide_percent",            limit: 4
    t.integer  "level_percent",            limit: 4
    t.integer  "point_percent",            limit: 4
    t.string   "receipt_number",           limit: 255
    t.integer  "user_id",                  limit: 4
    t.boolean  "core_point_added",         limit: 1,     default: false, null: false
    t.boolean  "core_point_subtracted",    limit: 1,     default: false, null: false
    t.boolean  "shop_point_added",         limit: 1,     default: false, null: false
    t.boolean  "shop_point_subtracted",    limit: 1,     default: false, null: false
    t.boolean  "comment_added",            limit: 1,     default: false, null: false
  end

  create_table "shop_users", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "sex",                        limit: 255
    t.string   "pic",                        limit: 255
    t.date     "birthday"
    t.text     "friend_ids",                 limit: 65535
    t.datetime "login_at"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "lock_version",               limit: 4,     default: 0
    t.text     "cart_data",                  limit: 65535
    t.integer  "level_id",                   limit: 4,     default: 1
    t.integer  "editor_id",                  limit: 4
    t.integer  "suggested_level_id",         limit: 4
    t.integer  "percent",                    limit: 4
    t.string   "mall_ids",                   limit: 255
    t.integer  "trades_amount",              limit: 4
    t.text     "remark",                     limit: 65535
    t.integer  "trades_price_sum",           limit: 4
    t.integer  "trades_point",               limit: 4
    t.datetime "trades_point_calculated_at"
    t.datetime "level_modified_at"
    t.string   "id_number",                  limit: 255
    t.integer  "balance",                    limit: 4,     default: 0, null: false
    t.string   "crypted_password",           limit: 255
    t.string   "label",                      limit: 255
    t.string   "card_number",                limit: 255
    t.integer  "service_editor_id",          limit: 4
    t.integer  "customer_id",                limit: 4
    t.string   "texas_holdem_code",          limit: 255
  end

  create_table "shop_users_updatings", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "level_id",     limit: 4
    t.integer  "percent",      limit: 4
    t.string   "mall_ids",     limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "trades_point", limit: 4
    t.text     "remark",       limit: 65535
  end

  create_table "shop_values", force: :cascade do |t|
    t.integer  "editor_id",      limit: 4
    t.integer  "product_id",     limit: 4
    t.integer  "attribute_id",   limit: 4
    t.string   "content",        limit: 255
    t.boolean  "active",         limit: 1,   default: true, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "attribute_name", limit: 255
    t.integer  "lock_version",   limit: 4,   default: 0
  end

  add_index "shop_values", ["active", "attribute_id", "product_id"], name: "index_shop_values_on_active_and_attribute_id_and_product_id", using: :btree
  add_index "shop_values", ["active", "attribute_name", "content"], name: "by_active_and_attribute_name_and_content", using: :btree
  add_index "shop_values", ["active", "product_id"], name: "by_active_and_product_id", using: :btree
  add_index "shop_values", ["attribute_name"], name: "index_shop_values_on_attribute_name", using: :btree

  create_table "shop_videos", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.integer  "product_id",   limit: 4
    t.string   "pic",          limit: 255
    t.text     "description",  limit: 65535
    t.boolean  "active",       limit: 1,     default: true, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "mp4",          limit: 255
    t.string   "flv",          limit: 255
    t.string   "swf",          limit: 255
    t.boolean  "has_audio",    limit: 1
    t.integer  "lock_version", limit: 4,     default: 0
    t.string   "hd",           limit: 255
  end

  add_index "shop_videos", ["active", "product_id"], name: "by_active_and_product_id", using: :btree

  create_table "shop_vouchers", force: :cascade do |t|
    t.integer  "event_id",     limit: 4
    t.integer  "editor_id",    limit: 4
    t.integer  "user_id",      limit: 4
    t.integer  "trade_id",     limit: 4
    t.string   "identifier",   limit: 255
    t.datetime "obtained_at"
    t.datetime "used_at"
    t.text     "remark",       limit: 65535
    t.boolean  "active",       limit: 1,     default: true, null: false
    t.integer  "lock_version", limit: 4,     default: 0,    null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "shop_vouchers", ["active", "event_id"], name: "by_active_and_event_id", using: :btree
  add_index "shop_vouchers", ["active", "identifier"], name: "index_shop_vouchers_on_active_and_identifier", using: :btree
  add_index "shop_vouchers", ["active", "user_id"], name: "by_active_and_user_id", using: :btree
  add_index "shop_vouchers", ["identifier"], name: "index_shop_vouchers_on_identifier", using: :btree
  add_index "shop_vouchers", ["trade_id"], name: "index_shop_vouchers_on_trade_id", using: :btree

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "simple_captcha_data", ["key"], name: "index_simple_captcha_data_on_key", using: :btree

  create_table "stat_clicks", force: :cascade do |t|
    t.integer  "link_id",      limit: 4
    t.integer  "user_id",      limit: 4
    t.string   "referrer",     limit: 255
    t.string   "ip",           limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "url",          limit: 255
    t.string   "agent",        limit: 255
    t.string   "path",         limit: 255
    t.integer  "lock_version", limit: 4,   default: 0
    t.string   "session_key",  limit: 255
  end

  add_index "stat_clicks", ["link_id"], name: "index_stat_clicks_on_link_id", using: :btree

  create_table "stat_links", force: :cascade do |t|
    t.integer  "editor_id",    limit: 4
    t.string   "url",          limit: 255
    t.string   "source",       limit: 255
    t.string   "identifier",   limit: 255
    t.integer  "price",        limit: 4
    t.boolean  "active",       limit: 1,   default: true, null: false
    t.datetime "destroyed_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "name",         limit: 255
    t.string   "description",  limit: 255
    t.integer  "ad_id",        limit: 4
    t.integer  "lock_version", limit: 4,   default: 0
  end

  add_index "stat_links", ["active", "id"], name: "by_active_and_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "uploads", force: :cascade do |t|
    t.integer  "attachmentable_id",   limit: 4
    t.string   "attachmentable_type", limit: 255
    t.integer  "user_id",             limit: 4
    t.string   "file_key",            limit: 255
    t.string   "file_name",           limit: 255
    t.integer  "file_size",           limit: 4
    t.string   "file_type",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["attachmentable_id", "attachmentable_type"], name: "index_uploads_on_attachmentable", using: :btree
  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "nickname",                   limit: 255
    t.string   "name",                       limit: 255
    t.string   "pic",                        limit: 255
    t.string   "sex",                        limit: 255
    t.string   "qq",                         limit: 255
    t.string   "phone",                      limit: 255
    t.text     "description",                limit: 65535
    t.string   "email",                      limit: 255,   default: "",       null: false
    t.string   "encrypted_password",         limit: 255,   default: "",       null: false
    t.string   "reset_password_token",       limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              limit: 4,     default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",         limit: 255
    t.string   "last_sign_in_ip",            limit: 255
    t.string   "confirmation_token",         limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",          limit: 255
    t.string   "role",                       limit: 255,   default: "normal", null: false
    t.date     "birthday"
    t.text     "friend_ids",                 limit: 65535
    t.datetime "login_at"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "lock_version",               limit: 4,     default: 0
    t.text     "cart_data",                  limit: 65535
    t.integer  "level_id",                   limit: 4,     default: 1
    t.integer  "editor_id",                  limit: 4
    t.integer  "suggested_level_id",         limit: 4
    t.integer  "percent",                    limit: 4
    t.string   "mall_ids",                   limit: 255
    t.integer  "trades_amount",              limit: 4
    t.text     "remark",                     limit: 65535
    t.integer  "trades_price_sum",           limit: 4
    t.integer  "trades_point",               limit: 4
    t.datetime "trades_point_calculated_at"
    t.datetime "level_modified_at"
    t.string   "id_number",                  limit: 255
    t.integer  "balance",                    limit: 4,     default: 0,        null: false
    t.string   "label",                      limit: 255
    t.string   "card_number",                limit: 255
    t.integer  "service_editor_id",          limit: 4
    t.integer  "customer_id",                limit: 4
    t.string   "texas_holdem_code",          limit: 255
    t.string   "crypted_password",           limit: 255
    t.integer  "point",                      limit: 4
    t.integer  "shop_point",                 limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
