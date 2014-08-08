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

ActiveRecord::Schema.define(version: 20140808010216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: true do |t|
    t.integer  "instance_id",  null: false
    t.integer  "round_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
    t.string   "dingus"
    t.string   "token_string"
    t.integer  "token_id"
    t.binary   "memo"
  end

  add_index "availabilities", ["instance_id", "round_id"], name: "index_availabilities_on_instance_id_and_round_id", unique: true, using: :btree
  add_index "availabilities", ["instance_id"], name: "index_availabilities_on_instance_id", using: :btree
  add_index "availabilities", ["round_id"], name: "index_availabilities_on_round_id", using: :btree
  add_index "availabilities", ["token_id"], name: "index_availabilities_on_token_id", using: :btree

  create_table "captures", force: true do |t|
    t.integer  "redemption_id", null: false
    t.integer  "flag_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id",      null: false
  end

  add_index "captures", ["flag_id"], name: "index_captures_on_flag_id", using: :btree
  add_index "captures", ["redemption_id"], name: "index_captures_on_redemption_id", using: :btree

  create_table "flags", force: true do |t|
    t.integer  "team_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_id", null: false
  end

  add_index "flags", ["service_id"], name: "index_flags_on_service_id", using: :btree
  add_index "flags", ["team_id"], name: "index_flags_on_team_id", using: :btree

  create_table "instances", force: true do |t|
    t.integer  "team_id",    null: false
    t.integer  "service_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instances", ["service_id"], name: "index_instances_on_service_id", using: :btree
  add_index "instances", ["team_id"], name: "index_instances_on_team_id", using: :btree

  create_table "penalties", force: true do |t|
    t.integer  "availability_id", null: false
    t.integer  "team_id",         null: false
    t.integer  "flag_id",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "penalties", ["availability_id"], name: "index_penalties_on_availability_id", using: :btree
  add_index "penalties", ["flag_id"], name: "index_penalties_on_flag_id", using: :btree
  add_index "penalties", ["team_id"], name: "index_penalties_on_team_id", using: :btree

  create_table "redemptions", force: true do |t|
    t.integer  "team_id",    null: false
    t.integer  "token_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id",   null: false
    t.uuid     "uuid",       null: false
  end

  add_index "redemptions", ["team_id", "token_id"], name: "index_redemptions_on_team_id_and_token_id", unique: true, using: :btree
  add_index "redemptions", ["team_id"], name: "index_redemptions_on_team_id", using: :btree
  add_index "redemptions", ["token_id"], name: "index_redemptions_on_token_id", using: :btree

  create_table "rounds", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ended_at"
    t.string   "nonce"
    t.json     "payload"
    t.string   "signature"
    t.json     "distribution"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.uuid     "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "certname"
    t.string   "address"
    t.integer  "dupe_ctr",     default: 0
    t.integer  "old_ctr",      default: 0
    t.integer  "notfound_ctr", default: 0
    t.integer  "self_ctr",     default: 0
    t.integer  "other_ctr",    default: 0
  end

  add_index "teams", ["certname"], name: "index_teams_on_certname", unique: true, using: :btree
  add_index "teams", ["uuid"], name: "index_teams_on_uuid", unique: true, using: :btree

  create_table "tickets", force: true do |t|
    t.integer  "team_id",     null: false
    t.text     "body"
    t.datetime "resolved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["team_id"], name: "index_tickets_on_team_id", using: :btree

  create_table "timers", force: true do |t|
    t.string   "name"
    t.datetime "ending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: true do |t|
    t.string   "key",               null: false
    t.string   "digest"
    t.integer  "instance_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id",          null: false
    t.integer  "status"
    t.integer  "redemptions_count"
    t.binary   "memo"
  end

  add_index "tokens", ["instance_id", "round_id"], name: "index_tokens_on_instance_id_and_round_id", unique: true, using: :btree
  add_index "tokens", ["instance_id"], name: "index_tokens_on_instance_id", using: :btree

end
