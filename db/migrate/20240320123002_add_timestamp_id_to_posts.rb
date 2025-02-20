class AddTimestampIdToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :timestamp_id, :string
    add_index :posts, :timestamp_id, unique: true
  end
end
