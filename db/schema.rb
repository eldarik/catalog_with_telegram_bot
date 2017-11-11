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

ActiveRecord::Schema.define(version: 20171111094925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["department_id"], name: "index_categories_on_department_id", using: :btree
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

  create_table "clients", force: :cascade do |t|
    t.string   "telegram_uid"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["telegram_uid"], name: "index_clients_on_telegram_uid", unique: true, using: :btree
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_departments_on_name", unique: true, using: :btree
  end

  create_table "order_elements", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_elements_on_order_id", using: :btree
    t.index ["product_id"], name: "index_order_elements_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "client_id"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_orders_on_client_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
    t.index ["name"], name: "index_products_on_name", using: :btree
  end

  add_foreign_key "categories", "departments"
  add_foreign_key "order_elements", "orders"
  add_foreign_key "order_elements", "products"
  add_foreign_key "orders", "clients"
  add_foreign_key "products", "categories"
end
