class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.references :sender
      t.references :recipient
      t.float :amount

      t.timestamps
    end
  end
end
