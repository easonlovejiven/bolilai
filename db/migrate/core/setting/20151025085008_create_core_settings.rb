class CreateCoreSettings < ActiveRecord::Migration
  def change
    create_table "core_settings" do |t|
      t.string "profile"
      t.string "friend"
      t.string "feed"
      t.string "basic"
      t.string "personal"
      t.string "work"
      t.string "im"
      t.string "mobile"
      t.string "phone"
      t.string "website"
      t.string "email"
      t.string "search"
      t.boolean "my_profile_picture"
      t.boolean "my_friend_list"
      t.boolean "a_link_to_add_me_as_a_friend"
      t.boolean "a_link_to_send_me_a_message"
      t.boolean "search_engine_indexing"
      t.boolean "sends_me_a_message"
      t.boolean "adds_me_as_a_friend"
      t.boolean "confirms_a_friendship_request"
      t.boolean "suggests_a_friend_to_me"
      t.boolean "adds_a_friend_i_suggested"
      t.boolean "i_invited_joins_facebook"
      t.boolean "has_a_birthday_coming_up"
      t.boolean "pokes_me"
      t.boolean "posts_on_my_wall"
      t.boolean "comments_on_a_story_in_my_wall"
      t.boolean "comments_after_me_on_a_wall_story"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string "note"
      t.string "photo"
      t.string "share"
      t.boolean "public_search", :default => true
      t.boolean "public_online_status"
      t.boolean "receive_promotion_email"
      t.boolean "receive_promotion_email_of_event", :default => true
      t.boolean "receive_promotion_email_of_voucher", :default => true
      t.boolean "receive_promotion_email_of_news", :default => true
      t.boolean "receive_promotion_email_of_recommend", :default => true
      t.boolean "receive_promotion_sms_of_event", :default => true
      t.boolean "receive_promotion_sms_of_voucher", :default => true
      t.boolean "receive_promotion_sms_of_promote", :default => true
    end

    add_index "core_settings", ["a_link_to_add_me_as_a_friend"], :name => "index_core_settings_on_a_link_to_add_me_as_a_friend"
    add_index "core_settings", ["a_link_to_send_me_a_message"], :name => "index_core_settings_on_a_link_to_send_me_a_message"
    add_index "core_settings", ["adds_a_friend_i_suggested"], :name => "index_core_settings_on_adds_a_friend_i_suggested"
    add_index "core_settings", ["adds_me_as_a_friend"], :name => "index_core_settings_on_adds_me_as_a_friend"
    add_index "core_settings", ["comments_after_me_on_a_wall_story"], :name => "index_core_settings_on_comments_after_me_on_a_wall_story"
    add_index "core_settings", ["comments_on_a_story_in_my_wall"], :name => "index_core_settings_on_comments_on_a_story_in_my_wall"
    add_index "core_settings", ["confirms_a_friendship_request"], :name => "index_core_settings_on_confirms_a_friendship_request"
    add_index "core_settings", ["created_at"], :name => "index_core_settings_on_created_at"
    add_index "core_settings", ["has_a_birthday_coming_up"], :name => "index_core_settings_on_has_a_birthday_coming_up"
    add_index "core_settings", ["i_invited_joins_facebook"], :name => "index_core_settings_on_i_invited_joins_facebook"
    add_index "core_settings", ["id"], :name => "index_core_settings_on_id"
    add_index "core_settings", ["my_friend_list"], :name => "index_core_settings_on_my_friend_list"
    add_index "core_settings", ["my_profile_picture"], :name => "index_core_settings_on_my_profile_picture"
    add_index "core_settings", ["pokes_me"], :name => "index_core_settings_on_pokes_me"
    add_index "core_settings", ["posts_on_my_wall"], :name => "index_core_settings_on_posts_on_my_wall"
    add_index "core_settings", ["search_engine_indexing"], :name => "index_core_settings_on_search_engine_indexing"
    add_index "core_settings", ["sends_me_a_message"], :name => "index_core_settings_on_sends_me_a_message"
    add_index "core_settings", ["suggests_a_friend_to_me"], :name => "index_core_settings_on_suggests_a_friend_to_me"
    add_index "core_settings", ["updated_at"], :name => "index_core_settings_on_updated_at"

  end
end
