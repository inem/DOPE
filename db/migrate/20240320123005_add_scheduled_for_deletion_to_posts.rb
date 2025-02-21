class AddScheduledForDeletionToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :scheduled_for_deletion_at, :datetime
    add_index :posts, :scheduled_for_deletion_at
  end
end
