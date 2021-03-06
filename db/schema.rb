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

ActiveRecord::Schema.define(version: 20150221192553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "agents", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "hostname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dispositions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "fingerprint"
    t.integer  "state"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "dispositions", ["fingerprint"], name: "index_dispositions_on_fingerprint", unique: true, using: :btree

  create_table "events", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "type"
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid     "agent_id",   null: false
  end

  add_index "events", ["agent_id"], name: "index_events_on_agent_id", using: :btree

  create_table "file_reports", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "disposition_id"
    t.json     "data"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "username",        null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
