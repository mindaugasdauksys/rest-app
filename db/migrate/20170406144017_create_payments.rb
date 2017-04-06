class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :from
      t.integer :to
      t.float :amount
      t.timestamps
    end
  end
end
