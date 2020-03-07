# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_02_070742) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "election_data", force: :cascade do |t|
    t.bigint "election_id", null: false
    t.bigint "candidate_id"
    t.integer "votes_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["candidate_id"], name: "index_election_data_on_candidate_id"
    t.index ["election_id"], name: "index_election_data_on_election_id"
  end

  create_table "elections", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "title"
    t.text "description"
    t.text "additional_information"
    t.datetime "deadline_for_registration"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "status", default: 0
    t.integer "approval_status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_elections_on_admin_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "message_sender_id"
    t.bigint "message_receiver_id"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_receiver_id"], name: "index_messages_on_message_receiver_id"
    t.index ["message_sender_id"], name: "index_messages_on_message_sender_id"
  end

  create_table "pending_voters", force: :cascade do |t|
    t.bigint "election_id", null: false
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["election_id"], name: "index_pending_voters_on_election_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "request_sender_id"
    t.bigint "election_id"
    t.string "purpose"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["election_id"], name: "index_requests_on_election_id"
    t.index ["request_sender_id"], name: "index_requests_on_request_sender_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_name"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.date "birth_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "voting_lists", force: :cascade do |t|
    t.bigint "voter_id"
    t.bigint "election_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["election_id"], name: "index_voting_lists_on_election_id"
    t.index ["voter_id"], name: "index_voting_lists_on_voter_id"
  end

  create_table "winners", force: :cascade do |t|
    t.bigint "election_id", null: false
    t.bigint "election_datum_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["election_datum_id"], name: "index_winners_on_election_datum_id"
    t.index ["election_id"], name: "index_winners_on_election_id"
  end

  add_foreign_key "election_data", "elections"
  add_foreign_key "pending_voters", "elections"
  add_foreign_key "winners", "election_data"
  add_foreign_key "winners", "elections"
end
