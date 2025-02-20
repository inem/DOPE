class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :auth_token
      t.string :uuid, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :auth_token, unique: true
    add_index :users, :uuid, unique: true
  end
end
