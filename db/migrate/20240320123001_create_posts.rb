class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :posts }, null: true
      t.text :content, null: false
      t.string :uuid, null: false
      t.integer :version
      t.float :similarity
      t.boolean :latest, default: true
      t.string :content_hash
      t.string :prefix_hash

      t.timestamps
    end

    add_index :posts, :uuid, unique: true
    add_index :posts, :content_hash
    add_index :posts, :prefix_hash
  end
end
