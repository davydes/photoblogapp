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

ActiveRecord::Schema.define(version: 20150226105817) do

  create_table "activities", force: true do |t|
    t.integer  "user_id",      null: false
    t.string   "subject_type", null: false
    t.integer  "subject_id",   null: false
    t.string   "name",         null: false
    t.string   "direction",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "activities", ["subject_type", "subject_id"], name: "index_activities_on_subject_type_and_subject_id"
  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "albums", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "albums", ["user_id"], name: "index_albums_on_user_id"

  create_table "albums_photos", id: false, force: true do |t|
    t.integer "album_id"
    t.integer "photo_id"
  end

  add_index "albums_photos", ["album_id", "photo_id"], name: "index_albums_photos_on_album_id_and_photo_id", unique: true
  add_index "albums_photos", ["photo_id"], name: "index_albums_photos_on_photo_id"

  create_table "articles", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",                default: false
    t.datetime "published_at"
    t.text     "intro",        limit: 255
    t.boolean  "sandbox",                  default: false, null: false
    t.datetime "sandbox_at"
  end

  add_index "articles", ["user_id"], name: "index_articles_on_user_id"

  create_table "articles_photos", id: false, force: true do |t|
    t.integer "article_id"
    t.integer "photo_id"
  end

  add_index "articles_photos", ["article_id", "photo_id"], name: "index_articles_photos_on_article_id_and_photo_id", unique: true
  add_index "articles_photos", ["photo_id"], name: "index_articles_photos_on_photo_id"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "photos", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.binary   "exif_binary"
  end

  add_index "photos", ["user_id"], name: "index_photos_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                               default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender",                    limit: 1
    t.string   "country"
    t.string   "city"
    t.date     "date_of_birth"
    t.integer  "photo_upload_daily_limit"
    t.integer  "photo_upload_weekly_limit"
    t.datetime "last_login_time"
    t.boolean  "publisher",                           default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["password_reset_token"], name: "index_users_on_password_reset_token", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

  create_table "votes", force: true do |t|
    t.integer  "user_id"
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id"], name: "index_votes_on_user_id"
  add_index "votes", ["voteable_type", "voteable_id"], name: "index_votes_on_voteable_type_and_voteable_id"

end
