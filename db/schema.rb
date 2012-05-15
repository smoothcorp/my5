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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120514142704) do

  create_table "activities", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  create_table "audio_programs", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "audio_programs", ["id"], :name => "index_audio_programs_on_id"

  create_table "audios", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.integer  "my_eq_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "audio_program_id"
    t.text     "embed_code"
    t.string   "wistia_video_id"
  end

  add_index "audios", ["id"], :name => "index_audios_on_id"

  create_table "bodyparts", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corporations", :force => true do |t|
    t.string   "name"
    t.integer  "logo_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  add_index "corporations", ["id"], :name => "index_corporations_on_id"

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "contact_phone"
    t.string   "role"
    t.integer  "corporation_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                               :default => "",       :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",       :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "street_1"
    t.string   "street_2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "title"
    t.string   "eway_token"
    t.string   "card_number"
    t.string   "card_expiry_date"
    t.integer  "department_id"
    t.boolean  "renew_subscription",                  :default => true
    t.string   "card_name"
    t.string   "time_zone",                           :default => "Sydney", :null => false
    t.string   "promo_code"
    t.integer  "free_trial_opted",     :limit => 1
  end

  add_index "customers", ["email"], :name => "index_customers_on_email", :unique => true
  add_index "customers", ["id"], :name => "index_customers_on_id"
  add_index "customers", ["reset_password_token"], :name => "index_customers_on_reset_password_token", :unique => true

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "corporation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "stub"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "health_checkins", :force => true do |t|
    t.integer  "stress_rating"
    t.integer  "energy_rating"
    t.integer  "comfort_rating"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  create_table "images", :force => true do |t|
    t.string   "image_mime_type"
    t.string   "image_name"
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_uid"
    t.string   "image_ext"
  end

  create_table "mini_modules", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mini_modules", ["id"], :name => "index_mini_modules_on_id"

  create_table "my_eqs", :force => true do |t|
    t.string   "emotional_grouping"
    t.text     "step_two"
    t.text     "step_three"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.text     "step_four"
    t.integer  "image_id"
    t.string   "audio_step_1"
    t.string   "audio_step_5"
    t.text     "audio_step_1_embed_code"
    t.text     "audio_step_5_embed_code"
    t.string   "audio_step_1_wistia_video_id"
    t.string   "audio_step_5_wistia_video_id"
  end

  add_index "my_eqs", ["id"], :name => "index_my_eqs_on_id"

  create_table "occurences", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "session_id"
  end

  create_table "page_part_translations", :force => true do |t|
    t.integer  "page_part_id"
    t.string   "locale"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_part_translations", ["page_part_id"], :name => "index_page_part_translations_on_page_part_id"

  create_table "page_parts", :force => true do |t|
    t.integer  "page_id"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_parts", ["id"], :name => "index_page_parts_on_id"
  add_index "page_parts", ["page_id"], :name => "index_page_parts_on_page_id"

  create_table "page_translations", :force => true do |t|
    t.integer  "page_id"
    t.string   "locale"
    t.string   "title"
    t.string   "custom_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_in_menu",        :default => true
    t.string   "link_url"
    t.string   "menu_match"
    t.boolean  "deletable",           :default => true
    t.string   "custom_title_type",   :default => "none"
    t.boolean  "draft",               :default => false
    t.boolean  "skip_to_first_child", :default => false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "custom_position"
  end

  add_index "pages", ["depth"], :name => "index_pages_on_depth"
  add_index "pages", ["id"], :name => "index_pages_on_id"
  add_index "pages", ["lft"], :name => "index_pages_on_lft"
  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"
  add_index "pages", ["rgt"], :name => "index_pages_on_rgt"

  create_table "payments", :force => true do |t|
    t.integer  "subscription_id"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",          :default => 0
    t.string   "invoice_no"
  end

  create_table "programs", :force => true do |t|
    t.decimal  "price",      :precision => 10, :scale => 0
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "programs", ["id"], :name => "index_programs_on_id"

  create_table "refinery_settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.boolean  "destroyable",             :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scoping"
    t.boolean  "restricted",              :default => false
    t.string   "callback_proc_as_string"
    t.string   "form_value_type"
  end

  add_index "refinery_settings", ["name"], :name => "index_refinery_settings_on_name"

  create_table "reminder_emails", :force => true do |t|
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "time"
    t.string   "days_of_week"
  end

  create_table "resources", :force => true do |t|
    t.string   "file_mime_type"
    t.string   "file_name"
    t.integer  "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_uid"
    t.string   "file_ext"
  end

  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "seo_meta", :force => true do |t|
    t.integer  "seo_meta_id"
    t.string   "seo_meta_type"
    t.string   "browser_title"
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "seo_meta", ["id"], :name => "index_seo_meta_on_id"
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], :name => "index_seo_meta_on_seo_meta_id_and_seo_meta_type"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
    t.string   "locale"
  end

  add_index "slugs", ["locale"], :name => "index_slugs_on_locale"
  add_index "slugs", ["name", "sluggable_type", "scope", "sequence"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "customer_id"
    t.datetime "expiry_date"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_token"
    t.integer  "plan",           :default => 1
    t.integer  "status",         :default => 0
  end

  add_index "subscriptions", ["id"], :name => "index_subscriptions_on_id"

  create_table "symptomatics", :force => true do |t|
    t.integer  "body_part"
    t.string   "condition"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "slug"
  end

  add_index "symptomatics", ["id"], :name => "index_symptomatics_on_id"

  create_table "transactions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
  end

  create_table "user_plugins", :force => true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "user_plugins", ["name"], :name => "index_user_plugins_on_title"
  add_index "user_plugins", ["user_id", "name"], :name => "index_unique_user_plugins", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username",             :null => false
    t.string   "email",                :null => false
    t.string   "encrypted_password",   :null => false
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.string   "remember_token"
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
  end

  add_index "users", ["id"], :name => "index_users_on_id"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.integer  "symptomatic_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mini_module_id"
    t.text     "embed_code"
    t.string   "wistia_video_id"
  end

  add_index "videos", ["id"], :name => "index_videos_on_id"

end
