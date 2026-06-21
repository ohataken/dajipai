# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_21_054132) do
  create_table "card_descriptions", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_card_descriptions_on_card_id"
  end

  create_table "card_tags", force: :cascade do |t|
    t.integer "card_id", null: false
    t.datetime "created_at", null: false
    t.integer "tag_id", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id", "tag_id"], name: "index_card_tags_on_card_id_and_tag_id", unique: true
    t.index ["card_id"], name: "index_card_tags_on_card_id"
    t.index ["tag_id"], name: "index_card_tags_on_tag_id"
  end

  create_table "cards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "pinyin", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["uuid"], name: "index_cards_on_uuid", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  add_foreign_key "card_descriptions", "cards"
  add_foreign_key "card_tags", "cards"
  add_foreign_key "card_tags", "tags"
end
