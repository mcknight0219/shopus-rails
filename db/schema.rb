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

ActiveRecord::Schema.define(version: 20160506225229) do

  create_table "express_methods", force: :cascade do |t|
    t.string   "company",       limit: 255
    t.integer  "unit",          limit: 4
    t.decimal  "rate",                        precision: 10
    t.string   "country",       limit: 255
    t.integer  "duration",      limit: 4
    t.text     "description",   limit: 65535
    t.integer  "subscriber_id", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "express_methods", ["subscriber_id"], name: "index_express_methods_on_subscriber_id", using: :btree

  create_table "goods", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "brand",             limit: 255
    t.string   "currency",          limit: 255
    t.decimal  "price",                           precision: 10
    t.text     "description",       limit: 65535
    t.integer  "subscriber_id",     limit: 4
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "express_method_id", limit: 4
  end

  add_index "goods", ["express_method_id"], name: "index_goods_on_express_method_id", using: :btree
  add_index "goods", ["subscriber_id"], name: "index_goods_on_subscriber_id", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "weixin",     limit: 255
    t.boolean  "is_seller"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "express_methods", "subscribers"
  add_foreign_key "goods", "express_methods"
  add_foreign_key "goods", "subscribers"
end
