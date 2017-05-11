class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :auth_token
      t.string :password_digest
      t.datetime :auth_token_created_at
      t.timestamps
    end
  end
end
