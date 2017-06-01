# accounts migration
class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :surname
      t.string :currency
      t.float :amount
    end
  end
end
