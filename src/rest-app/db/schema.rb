ActiveRecord::Schema.define(version: 20170406145852) do

  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "currency"
    t.float  "amount"
  end

  create_table "branches", force: :cascade do |t|
    t.string "address"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "from"
    t.integer  "to"
    t.float    "amount"
    t.string   "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
