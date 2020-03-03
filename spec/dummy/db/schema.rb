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

ActiveRecord::Schema.define(version: 2019_03_02_165754) do

  create_table "group_posts", force: :cascade do |t|
    t.integer "group_id"
    t.integer "author_id"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_group_posts_on_author_id"
    t.index ["group_id"], name: "index_group_posts_on_group_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_people_on_email", unique: true
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer "actor_id"
    t.integer "role_id"
    t.string "resource_type"
    t.integer "resource_id"
    t.index ["actor_id"], name: "index_role_assignments_on_actor_id"
    t.index ["resource_type", "resource_id"], name: "index_role_assignments_on_resource_type_and_resource_id"
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_user_groups_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "group_posts", "people", column: "author_id"
  add_foreign_key "group_posts", "user_groups", column: "group_id"
  add_foreign_key "role_assignments", "people", column: "actor_id"
  add_foreign_key "role_assignments", "roles"
  add_foreign_key "user_groups", "people", column: "owner_id"
  add_foreign_key "users", "people", column: "id"
end
