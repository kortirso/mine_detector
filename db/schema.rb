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

ActiveRecord::Schema.define(version: 20160326092841) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cells", force: :cascade do |t|
    t.string   "x_param"
    t.string   "y_param"
    t.integer  "game_id"
    t.boolean  "has_mine",   default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name"
    t.boolean  "opened",     default: false
    t.integer  "around",     default: 0
    t.boolean  "marked",     default: false
  end

  add_index "cells", ["game_id"], name: "index_cells_on_game_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "game_result", default: "none"
    t.string   "empties",     default: [],                  array: true
    t.integer  "mines_count"
    t.integer  "user_id"
    t.string   "guest"
    t.integer  "times",       default: 0
    t.integer  "starttime",   default: 0
  end

  add_index "games", ["user_id"], name: "index_games_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
