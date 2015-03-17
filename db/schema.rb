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

ActiveRecord::Schema.define(version: 20150313033202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: true do |t|
    t.string   "company_name"
    t.text     "about"
    t.string   "phone_number"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_token"
    t.string   "stripe_subscription_token"
    t.integer  "storage_usage"
  end

  add_index "accounts", ["plan_id"], name: "index_accounts_on_plan_id", using: :btree

  create_table "ahoy_events", id: :uuid, force: true do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "name"
    t.json     "properties"
    t.datetime "time"
  end

  add_index "ahoy_events", ["time"], name: "index_ahoy_events_on_time", using: :btree
  add_index "ahoy_events", ["user_id", "user_type"], name: "index_ahoy_events_on_user_id_and_user_type", using: :btree
  add_index "ahoy_events", ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
  add_index "ahoy_events", ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.hstore   "socical",    default: ""
  end

  add_index "contacts", ["account_id"], name: "index_contacts_on_account_id", using: :btree

  create_table "forms", force: true do |t|
    t.string   "name"
    t.json     "fields"
    t.integer  "column_style"
    t.text     "styles"
    t.text     "scripts"
    t.json     "emails"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ecommerce_type"
    t.text     "thank_msg"
  end

  add_index "forms", ["account_id"], name: "index_forms_on_account_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "image"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["viewable_id", "viewable_type"], name: "index_images_on_viewable_id_and_viewable_type", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.decimal  "price"
    t.integer  "users"
    t.integer  "forms"
    t.integer  "storage"
    t.integer  "requests"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", force: true do |t|
    t.decimal  "amount",       precision: 10, scale: 2
    t.json     "options"
    t.string   "token"
    t.datetime "expires_at"
    t.integer  "request_id"
    t.text     "description"
    t.text     "signature"
    t.string   "status"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "template_id"
    t.integer  "email_sent",                            default: 0
    t.integer  "email_opened",                          default: 0
  end

  add_index "quotes", ["account_id"], name: "index_quotes_on_account_id", using: :btree
  add_index "quotes", ["request_id"], name: "index_quotes_on_request_id", using: :btree
  add_index "quotes", ["template_id"], name: "index_quotes_on_template_id", using: :btree

  create_table "requests", force: true do |t|
    t.json     "fields"
    t.integer  "form_id"
    t.string   "status"
    t.integer  "account_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["account_id"], name: "index_requests_on_account_id", using: :btree
  add_index "requests", ["contact_id"], name: "index_requests_on_contact_id", using: :btree
  add_index "requests", ["form_id"], name: "index_requests_on_form_id", using: :btree

  create_table "templates", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.text     "description"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "templates", ["account_id"], name: "index_templates_on_account_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "visits", id: :uuid, force: true do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
  end

  add_index "visits", ["eventable_id", "eventable_type"], name: "index_visits_on_eventable_id_and_eventable_type", using: :btree
  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
