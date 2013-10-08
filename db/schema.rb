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

ActiveRecord::Schema.define(version: 20131004184143) do

  create_table "positions", force: true do |t|
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitud"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "twitter_account"
    t.string   "facebook_account"
    t.string   "email"
    t.string   "password_digest"
    t.string   "blood_type"
    t.string   "alergies",                 default: "none"
    t.text     "home_addres"
    t.string   "emergency_state",          default: "unknown"
    t.float    "latitude_position"
    t.float    "longitude_position"
    t.string   "emergency_contact_number"
    t.string   "medications_taken",        default: "none"
    t.string   "session_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zones", force: true do |t|
    t.string   "name"
    t.float    "latitude_position"
    t.float    "longitude_position"
    t.boolean  "zone_type",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
