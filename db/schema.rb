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

ActiveRecord::Schema.define(version: 20190721034859) do

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin" do |t|
    t.string   "email",                            null: false
    t.string   "password",                         null: false
    t.string   "name",                             null: false
    t.string   "postal_code",                      null: false
    t.string   "address1",                         null: false
    t.string   "address2",                         null: false
    t.text     "description",        limit: 65535
    t.string   "last_name",                        null: false
    t.string   "first_name",                       null: false
    t.integer  "administrator_flag",               null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "password_digest"
    t.integer  "prefecture_id",                    null: false
  end

end
