class AddStateToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :state, :string, default: 'draft'
    add_index :posts, :state

    # Если уже есть колонка для scheduled_for_deletion_at, можно использовать её
    # Если нет, то удаляем комментарий:
    # add_column :posts, :scheduled_for_deletion_at, :datetime
  end
end
