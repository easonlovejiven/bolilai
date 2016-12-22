class InitShop < ActiveRecord::Migration
  create_table "shop_products", :force => true do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.string "pic"
    t.decimal "price", :precision => 10, :scale => 0
    t.decimal "discount", :precision => 10, :scale => 0
    t.boolean "published", :default => false, :null => false
    t.boolean "active", :default => true
    t.datetime "destroyed_at"
    t.datetime "arrived_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "cart_pic"
    t.string "spec_pic"
    t.string "color_pic"
    t.string "color_name"
    t.string "identifier"
    t.string "keywords"
    t.string "brand_link"
    t.text "brand_description"
    t.text "material"
    t.integer "percent"
    t.integer "image_id"
    t.integer "market_id"
    t.integer "category_id"
    t.string "relate_product_ids"
    t.boolean "rec", :default => false
    t.string "rec_pic"
    t.integer "order", :default => 1
    t.string "percent_text"
    t.text "accelerator"
    t.string "styles"
    t.integer "lock_version", :default => 0
    t.integer "sell_duration"
    t.integer "sell_total"
    t.integer "point", :default => 0, :null => false
    t.integer "video_id"
    t.integer "category1_id"
    t.integer "category2_id"
    t.integer "brand_id"
    t.text "attribute_data"
    t.integer "promotion_price"
    t.datetime "promotion_started_at"
    t.datetime "promotion_ended_at"
    t.datetime "published_at"
    t.string "color"
    t.string "recommend"
    t.string "target"
    t.string "match_pic"
    t.text "match_product_ids"
    t.string "major_pic"
    t.integer "sold_count"
    t.integer "unsold_count"
    t.string "measures_unsold_count"
    t.string "remark"
    t.string "label"
    t.string "prefix"
    t.text "discount_history"
    t.integer "scarcity", :default => 0, :null => false
    t.integer "readings_count", :default => 0, :null => false
    t.text "measure_table"
    t.integer "mall_id"
    t.string "fitting_pic"
    t.datetime "hourglass_started_at"
    t.integer "hourglass_rate"
    t.integer "hourglass_pause_duration"
    t.datetime "hourglass_trade_created_at"
    t.integer "hourglass_trade_price"
    t.integer "original_price"
    t.datetime "created_at"
    t.datetime "edited_at"
    t.string "measure_description"
    t.integer "zoom"
    t.integer "sell_current"
    t.string "measure_style"
    t.string "storage_location"
    t.text "measure_suggestion"
    t.integer "items_count"
    t.integer "items_unpublished_count"
    t.integer "items_unsold_count"
    t.string "origins"
    t.string "background"
    t.text "extra_description"
    t.string "extra_pic"
    t.string "model_pic"
    t.integer "minimum_price"
    t.string "detail_pic"
    t.integer "category3_id"
    t.string "download_pic"
    t.string "thickness"
    t.string "elasticity"
    t.string "pliability"
    t.integer "multibuy_id"
    t.integer "shop_price"
  end

  add_index "shop_products", ["active", "id"], :name => "by_active_and_id"
  add_index "shop_products", ["active", "published", "brand_id", "published_at"], :name => "by_active_and_published_and_brand_id_and_published_at"
  add_index "shop_products", ["active", "published", "category1_id", "published_at"], :name => "by_active_and_published_and_category1_id_and_published_at"
  add_index "shop_products", ["active", "published", "category2_id", "published_at"], :name => "by_active_and_published_and_category2_id_and_published_at"
  add_index "shop_products", ["active", "published", "color", "published_at"], :name => "by_active_and_published_and_color_and_published_at"
  add_index "shop_products", ["active", "published", "mall_id", "target", "published_at"], :name => "by_active_and_published_and_mall_id_and_target_and_published_at"
  add_index "shop_products", ["active", "published", "price", "published_at"], :name => "by_active_and_published_and_price_and_published_at"
  add_index "shop_products", ["active", "published", "published_at"], :name => "by_active_and_published_and_published_at"
  add_index "shop_products", ["active", "published", "recommend", "published_at"], :name => "by_active_and_published_and_recommend_and_published_at"
  add_index "shop_products", ["active", "published", "target", "published_at"], :name => "by_active_and_published_and_target_and_published_at"
  add_index "shop_products", ["brand_id", "target", "unsold_count"], :name => "by_brand_id_and_target_and_unsold_count"

  create_table "shop_products_updatings", :force => true do |t|
    t.integer "product_id"
    t.integer "editor_id"
    t.text "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean "published"
  end

  add_index "shop_products_updatings", ["product_id", "created_at"], :name => "by_product_id_and_created_at"

  create_table "shop_categories", :force => true do |t|
    t.integer "user_id"
    t.string "name"
    t.text "measures"
    t.boolean "active", :default => true
    t.datetime "destroyed_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "lock_version", :default => 0
    t.integer "parent_id"
    t.text "description"
    t.string "ranges"
    t.integer "order", :default => 1
    t.boolean "published", :default => false, :null => false
    t.string "attribute_ids"
    t.boolean "female", :default => false, :null => false
    t.boolean "male", :default => false, :null => false
    t.string "measure_properties"
    t.string "measure_pic"
    t.integer "bust_offset"
    t.integer "bust_error"
    t.integer "waistline_offset"
    t.integer "waistline_error"
    t.integer "hip_offset"
    t.integer "hip_error"
    t.integer "shoulder_offset"
    t.integer "shoulder_error"
    t.integer "arm_offset"
    t.integer "arm_error"
    t.integer "leg_offset"
    t.integer "leg_error"
    t.string "priority"
    t.string "contrast_pic"
    t.string "pic"
    t.string "pic_file_name"
    t.string "pic_content_type"
    t.integer "pic_file_size"
    t.datetime "pic_updated_at"
    t.integer "pic_image_width"
    t.integer "pic_image_height"
  end


  create_table "shop_attributes", :force => true do |t|
    t.integer "editor_id"
    t.string "name"
    t.text "option_list"
    t.boolean "searchable", :default => false, :null => false
    t.boolean "active", :default => true, :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "lock_version", :default => 0
  end

  add_index "shop_attributes", ["active", "id"], :name => "by_active_and_id"


  create_table "shop_values", :force => true do |t|
    t.integer "editor_id"
    t.integer "product_id"
    t.integer "attribute_id"
    t.string "content"
    t.boolean "active", :default => true, :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "attribute_name"
    t.integer "lock_version", :default => 0
  end

  add_index "shop_values", ["active", "attribute_id", "product_id"], :name => "index_shop_values_on_active_and_attribute_id_and_product_id"
  add_index "shop_values", ["active", "attribute_name", "content"], :name => "by_active_and_attribute_name_and_content"
  add_index "shop_values", ["active", "product_id"], :name => "by_active_and_product_id"
  add_index "shop_values", ["attribute_name"], :name => "index_shop_values_on_attribute_name"


  create_table "shop_contacts", :force => true do |t|
    t.integer "user_id"
    t.string "name"
    t.string "country"
    t.string "province"
    t.string "city"
    t.string "town"
    t.string "address"
    t.string "postcode"
    t.string "phone"
    t.string "mobile"
    t.boolean "active", :default => true
    t.datetime "destroyed_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer "lock_version", :default => 0
    t.integer "editor_id"
    t.string "delivery_service"
    t.text "remark"
  end

  create_table "shop_brand_images", :force => true do |t|
    t.string "pic"
    t.string "pic_file_name"
    t.integer "pic_file_size"
    t.string "pic_content_type"
    t.datetime "pic_updated_at"
    t.integer "pic_image_width"
    t.integer "pic_image_height"
    t.integer "sequence"
    t.integer "brand_id"
    t.boolean "active", :default => true, :null => false
    t.integer "lock_version", :default => 0, :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shop_brands", :force => true do |t|
    t.integer "editor_id"
    t.string "name"
    t.string "chinese"
    t.string "abbreviation"
    t.string "pic"
    t.string "website"
    t.text "description"
    t.integer "order", :default => 1
    t.string "recommend"
    t.boolean "published", :default => false, :null => false
    t.boolean "active", :default => true, :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "link"
    t.string "initial"
    t.string "swf"
    t.string "swf2"
    t.integer "lock_version", :default => 0
    t.string "title"
    t.string "pronunciation"
    t.integer "country_id"
    t.datetime "founded_on"
    t.string "keywords"
    t.string "special_product_ids"
    t.boolean "introduced"
    t.integer "year"
    t.string "shop_link"
    t.string "genre"
    t.string "material"
    t.text "summary"
  end


  create_table "shop_items", :force => true do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.boolean "active", :default => true
    t.datetime "destroyed_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string "measure"
    t.string "identifer"
    t.integer "trade_id"
    t.integer "lock_version", :default => 0
    t.boolean "published", :default => false, :null => false
    t.string "remark"
    t.string "original_measure"
    t.integer "purchase_type"
    t.datetime "storage_at"
    t.datetime "expired_at"
    t.string "factory_measure"
    t.string "standard_measure"
    t.string "origin"
    t.string "storage_name"
    t.string "store_num"
    t.decimal "cost_price", :precision => 8, :scale => 2, :default => 0.0
    t.string "barcode"
  end

  add_index "shop_items", ["active", "id"], :name => "by_active_and_id"
  add_index "shop_items", ["active", "product_id"], :name => "index_shop_items_on_active_and_product_id"
  add_index "shop_items", ["active", "published", "product_id", "measure"], :name => "by_active_and_published_and_product_id_and_measure"
  add_index "shop_items", ["identifer"], :name => "index_shop_items_on_identifer"

  create_table "shop_items_updatings", :force => true do |t|
    t.integer "item_id"
    t.integer "editor_id"
    t.boolean "published"
    t.integer "lock_version", :default => 0, :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end
  add_index "shop_items_updatings", ["item_id", "created_at"], :name => "by_item_id_and_created_at"
end
