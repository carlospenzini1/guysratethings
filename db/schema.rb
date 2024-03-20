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

ActiveRecord::Schema.define(version: 2022_04_20_185214) do

  create_table "comment_chains", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "parent_id", null: false
    t.integer "child_id", null: false
  end

  create_table "comment_likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "comment_id", null: false
    t.integer "user_id", null: false
  end

  create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.integer "list_id", null: false
    t.integer "user_id", null: false
    t.integer "likes", null: false
  end

  create_table "followers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "user_id", null: false
  end

  create_table "g_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "fname", null: false
    t.string "lname", null: false
    t.string "username", null: false
    t.string "password", null: false
    t.string "email", null: false
    t.string "profilepic"
    t.string "bio_text"
    t.datetime "created_at", null: false
    t.datetime "modified_at", null: false
    t.boolean "pic_approved", default: true, null: false
    t.boolean "active", default: true, null: false
    t.boolean "admin", default: false, null: false
    t.integer "guypoints", default: 0, null: false
  end

  create_table "images", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.string "img"
  end

  create_table "list_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "list_id", null: false
    t.string "description"
    t.string "title", null: false
    t.integer "rank", null: false
    t.integer "value", null: false
    t.string "itemimg"
  end

  create_table "list_likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "list_id", null: false
    t.integer "user_id", null: false
  end

  create_table "lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.string "lType", null: false
    t.datetime "created_at", null: false
    t.datetime "modified_at"
    t.boolean "active", null: false
    t.integer "likes", null: false
    t.boolean "approved", null: false
    t.string "unique", null: false
  end

  create_table "messages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb3", force: :cascade do |t|
    t.datetime "creation_date", null: false
    t.string "text", null: false
    t.integer "recipient_id", null: false
    t.integer "sender_id", null: false
    t.boolean "active", null: false
    t.boolean "read", null: false
  end

end
