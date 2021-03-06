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

ActiveRecord::Schema.define(version: 2021_04_21_150551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attr_values", force: :cascade do |t|
    t.string "value"
    t.bigint "observation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["observation_id"], name: "index_attr_values_on_observation_id"
  end

  create_table "datasets", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "share_link"
  end

  create_table "entries", force: :cascade do |t|
    t.string "text"
    t.bigint "dataset_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dataset_id"], name: "index_entries_on_dataset_id"
  end

  create_table "ml_features", force: :cascade do |t|
    t.bigint "entry_id"
    t.text "feature"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["entry_id"], name: "index_ml_features_on_entry_id"
  end

  create_table "ml_notations", force: :cascade do |t|
    t.bigint "entry_id", null: false
    t.bigint "attr_value_id", null: false
    t.bigint "observation_id", null: false
    t.float "certain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attr_value_id"], name: "index_ml_notations_on_attr_value_id"
    t.index ["entry_id"], name: "index_ml_notations_on_entry_id"
    t.index ["observation_id"], name: "index_ml_notations_on_observation_id"
  end

  create_table "ml_orders", force: :cascade do |t|
    t.bigint "entry_id", null: false
    t.bigint "observation_id", null: false
    t.integer "order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "effective_order"
    t.index ["entry_id"], name: "index_ml_orders_on_entry_id"
    t.index ["observation_id"], name: "index_ml_orders_on_observation_id"
  end

  create_table "notations", force: :cascade do |t|
    t.bigint "attr_value_id", null: false
    t.bigint "user_id", null: false
    t.bigint "entry_id", null: false
    t.bigint "observation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attr_value_id"], name: "index_notations_on_attr_value_id"
    t.index ["entry_id"], name: "index_notations_on_entry_id"
    t.index ["observation_id"], name: "index_notations_on_observation_id"
    t.index ["user_id"], name: "index_notations_on_user_id"
  end

  create_table "observations", force: :cascade do |t|
    t.string "name"
    t.bigint "dataset_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "accuracy"
    t.float "f1_score"
    t.datetime "last_run"
    t.integer "k_fold"
    t.boolean "interactive_learn"
    t.boolean "active_learn"
    t.integer "min_notations"
    t.index ["dataset_id"], name: "index_observations_on_dataset_id"
  end

  create_table "roles", force: :cascade do |t|
    t.binary "role", null: false
    t.bigint "user_id", null: false
    t.bigint "dataset_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dataset_id"], name: "index_roles_on_dataset_id"
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attr_values", "observations"
  add_foreign_key "entries", "datasets"
  add_foreign_key "ml_features", "entries"
  add_foreign_key "ml_notations", "attr_values"
  add_foreign_key "ml_notations", "entries"
  add_foreign_key "ml_notations", "observations"
  add_foreign_key "ml_orders", "entries"
  add_foreign_key "ml_orders", "observations"
  add_foreign_key "notations", "attr_values"
  add_foreign_key "notations", "entries"
  add_foreign_key "notations", "observations"
  add_foreign_key "notations", "users"
  add_foreign_key "observations", "datasets"
  add_foreign_key "roles", "datasets"
  add_foreign_key "roles", "users"
end
