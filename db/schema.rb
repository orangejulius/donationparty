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

ActiveRecord::Schema.define(:version => 20130204235130) do

  create_table "charities", :force => true do |t|
    t.string   "name"
    t.string   "image_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "donations", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "stripe_token"
    t.decimal  "amount"
    t.integer  "round_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "secret"
  end

  add_index "donations", ["round_id"], :name => "index_donations_on_round_id"

  create_table "rounds", :force => true do |t|
    t.string   "url"
    t.datetime "expire_time"
    t.boolean  "closed",           :default => false
    t.integer  "max_amount"
    t.string   "winning_address1"
    t.string   "winning_address2"
    t.string   "secret_token"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "charity_id"
  end

end
