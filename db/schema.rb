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

ActiveRecord::Schema.define(version: 20151106142720) do

  create_table "conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "employee_roles", force: :cascade do |t|
    t.integer "employee_id"
    t.integer "role_id"
  end

  add_index "employee_roles", ["employee_id"], name: "index_employee_roles_on_employee_id"
  add_index "employee_roles", ["role_id"], name: "index_employee_roles_on_role_id"

  create_table "employee_tasks", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "task_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "state",       default: 0
    t.integer  "role",        default: 0
    t.integer  "parent_id"
  end

  add_index "employee_tasks", ["employee_id"], name: "index_employee_tasks_on_employee_id"
  add_index "employee_tasks", ["task_id"], name: "index_employee_tasks_on_task_id"

  create_table "employees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_group",   default: false
  end

  add_index "employees", ["group_id"], name: "index_employees_on_group_id"
  add_index "employees", ["user_id"], name: "index_employees_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "account_id"
    t.integer  "account_state", default: 0
    t.string   "ancestry"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "groups", ["account_id"], name: "index_groups_on_account_id"
  add_index "groups", ["ancestry"], name: "index_groups_on_ancestry"

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.text     "text"
    t.integer  "employee_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "has_read",    default: false
  end

  add_index "notifications", ["employee_id"], name: "index_notifications_on_employee_id"

  create_table "proposals", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "supplier_id"
    t.integer  "receiver_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "to_group",    default: false
  end

  add_index "proposals", ["receiver_id"], name: "index_proposals_on_receiver_id"
  add_index "proposals", ["supplier_id"], name: "index_proposals_on_supplier_id"
  add_index "proposals", ["task_id"], name: "index_proposals_on_task_id"

  create_table "recipients", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "inbox",           default: true
    t.boolean  "read",            default: false
    t.boolean  "deleted",         default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "conversation_id"
    t.integer  "author_id"
  end

  add_index "recipients", ["author_id"], name: "index_recipients_on_author_id"
  add_index "recipients", ["conversation_id"], name: "index_recipients_on_conversation_id"
  add_index "recipients", ["message_id"], name: "index_recipients_on_message_id"
  add_index "recipients", ["user_id"], name: "index_recipients_on_user_id"

  create_table "roles", force: :cascade do |t|
    t.text     "name"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "deadline"
    t.boolean  "fire",           default: false, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "finished",       default: false, null: false
    t.datetime "finish_time"
    t.integer  "planning_state", default: 0
    t.integer  "sort_value"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
