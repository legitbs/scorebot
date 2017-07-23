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

ActiveRecord::Schema.define(version: 20170723153202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_replacements", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "service_id"
    t.bigint "round_id"
    t.string "digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["round_id"], name: "index_admin_replacements_on_round_id"
    t.index ["service_id"], name: "index_admin_replacements_on_service_id"
    t.index ["team_id"], name: "index_admin_replacements_on_team_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer "instance_id", null: false
    t.integer "round_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "status"
    t.string "token_string", limit: 255
    t.integer "token_id"
    t.binary "memo"
    t.binary "dingus"
    t.index ["instance_id", "round_id"], name: "index_availabilities_on_instance_id_and_round_id", unique: true
    t.index ["instance_id"], name: "index_availabilities_on_instance_id"
    t.index ["round_id"], name: "index_availabilities_on_round_id"
    t.index ["token_id"], name: "index_availabilities_on_token_id"
  end

  create_table "captures", force: :cascade do |t|
    t.integer "redemption_id", null: false
    t.integer "flag_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "round_id", null: false
    t.index ["flag_id"], name: "index_captures_on_flag_id"
    t.index ["redemption_id"], name: "index_captures_on_redemption_id"
  end

  create_table "flags", force: :cascade do |t|
    t.integer "team_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "service_id", null: false
    t.index ["service_id"], name: "index_flags_on_service_id"
    t.index ["team_id"], name: "index_flags_on_team_id"
  end

  create_table "instances", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "service_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["service_id"], name: "index_instances_on_service_id"
    t.index ["team_id"], name: "index_instances_on_team_id"
  end

  create_table "penalties", force: :cascade do |t|
    t.integer "availability_id", null: false
    t.integer "team_id", null: false
    t.integer "flag_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["availability_id"], name: "index_penalties_on_availability_id"
    t.index ["flag_id"], name: "index_penalties_on_flag_id"
    t.index ["team_id"], name: "index_penalties_on_team_id"
  end

  create_table "redemptions", force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "token_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "round_id", null: false
    t.uuid "uuid", null: false
    t.index ["team_id", "token_id"], name: "index_redemptions_on_team_id_and_token_id", unique: true
    t.index ["team_id"], name: "index_redemptions_on_team_id"
    t.index ["token_id"], name: "index_redemptions_on_token_id"
  end

  create_table "replacements", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "service_id"
    t.bigint "round_id"
    t.string "digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "size"
    t.index ["round_id"], name: "index_replacements_on_round_id"
    t.index ["service_id"], name: "index_replacements_on_service_id"
    t.index ["team_id", "service_id", "round_id"], name: "index_replacements_on_team_id_and_service_id_and_round_id", unique: true
    t.index ["team_id"], name: "index_replacements_on_team_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "ended_at"
    t.string "nonce", limit: 255
    t.json "payload"
    t.string "signature", limit: 255
    t.json "distribution"
  end

  create_table "services", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "enabled"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.uuid "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "certname"
    t.string "address"
    t.integer "dupe_ctr", default: 0
    t.integer "old_ctr", default: 0
    t.integer "notfound_ctr", default: 0
    t.integer "self_ctr", default: 0
    t.integer "other_ctr", default: 0
    t.string "display"
    t.index ["certname"], name: "index_teams_on_certname", unique: true
    t.index ["uuid"], name: "index_teams_on_uuid", unique: true
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "team_id", null: false
    t.text "body"
    t.datetime "resolved_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["team_id"], name: "index_tickets_on_team_id"
  end

  create_table "timers", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "ending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "key", limit: 255, null: false
    t.string "digest", limit: 255
    t.integer "instance_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "round_id", null: false
    t.integer "status"
    t.integer "redemptions_count"
    t.binary "memo"
    t.index ["instance_id", "round_id"], name: "index_tokens_on_instance_id_and_round_id", unique: true
    t.index ["instance_id"], name: "index_tokens_on_instance_id"
  end

  add_foreign_key "admin_replacements", "rounds"
  add_foreign_key "admin_replacements", "services"
  add_foreign_key "admin_replacements", "teams"
  add_foreign_key "replacements", "rounds"
  add_foreign_key "replacements", "services"
  add_foreign_key "replacements", "teams"
end
