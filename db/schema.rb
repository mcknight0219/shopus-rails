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

ActiveRecord::Schema.define(version: 20160518215348) do

  create_table "express_methods", force: :cascade do |t|
    t.string   "company",       limit: 255
    t.integer  "unit",          limit: 4
    t.float    "rate",          limit: 24
    t.string   "country",       limit: 255
    t.integer  "duration",      limit: 4
    t.text     "description",   limit: 65535
    t.integer  "subscriber_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "express_methods", ["subscriber_id"], name: "index_express_methods_on_subscriber_id", using: :btree

  create_table "goods", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "brand",             limit: 255
    t.string   "currency",          limit: 255
    t.float    "price",             limit: 24
    t.text     "description",       limit: 65535
    t.integer  "subscriber_id",     limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "express_method_id", limit: 4
  end

  add_index "goods", ["express_method_id"], name: "index_goods_on_express_method_id", using: :btree
  add_index "goods", ["subscriber_id"], name: "index_goods_on_subscriber_id", using: :btree

  create_table "logos", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url",  limit: 255
    t.binary "data", limit: 65535
  end

  create_table "product_photos", force: :cascade do |t|
    t.string   "format",        limit: 255
    t.string   "temp_path",     limit: 255
    t.boolean  "stored_remote"
    t.string   "media_id",      limit: 255
    t.integer  "good_id",       limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "product_photos", ["good_id"], name: "index_product_photos_on_good_id", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "weixin",     limit: 255
    t.boolean  "is_seller"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "express_methods", "subscribers"
  add_foreign_key "goods", "express_methods"
  add_foreign_key "goods", "subscribers"
  add_foreign_key "product_photos", "goods"
end
