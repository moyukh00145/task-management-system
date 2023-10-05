# rubocop:disable all
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
ActiveRecord::Schema.define(version: 20_231_001_082_725) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'notifications', force: :cascade do |t|
    t.integer 'sender_id'
    t.text 'message', null: false
    t.boolean 'read_status', default: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'notification_type', default: 0
    t.index ['user_id'], name: 'index_notifications_on_user_id'
  end

  create_table 'sub_tasks', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'status', default: 0
    t.text 'description'
    t.bigint 'task_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'uid'
    t.index ['task_id'], name: 'index_sub_tasks_on_task_id'
  end

  create_table 'task_categories', force: :cascade do |t|
    t.string 'task_name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'task_name', null: false
    t.datetime 'task_date'
    t.datetime 'task_time'
    t.integer 'repeat_interval'
    t.integer 'task_importance'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.bigint 'task_category_id', null: false
    t.string 'assign_by'
    t.integer 'status'
    t.text 'description'
    t.string 'attachments'
    t.datetime 'next_notification_date'
    t.boolean 'task_approval', default: false
    t.boolean 'sended_to_hr', default: false
    t.string 'uid'
    t.index ['task_category_id'], name: 'index_tasks_on_task_category_id'
    t.index ['user_id'], name: 'index_tasks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'employee_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.integer 'roles', default: 0
    t.string 'surname'
    t.string 'image'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'notifications', 'users', on_delete: :cascade
  add_foreign_key 'sub_tasks', 'tasks', on_delete: :cascade
  add_foreign_key 'tasks', 'task_categories'
  add_foreign_key 'tasks', 'users'
end
# rubocop:enable all
