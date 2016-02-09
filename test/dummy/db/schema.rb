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

ActiveRecord::Schema.define(version: 20160218200351) do

  create_table "access_tokens", force: :cascade do |t|
    t.string   "token"
    t.string   "authenticatee_type"
    t.integer  "authenticatee_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["authenticatee_type", "authenticatee_id"], name: "index_access_tokens_on_authenticatee_type_and_authenticatee_id"
    t.index ["token"], name: "index_access_tokens_on_token"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
