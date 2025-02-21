class CreatePostEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :post_entries do |t|
      t.string :timestamp_id, null: false
      t.references :user, null: false, foreign_key: true
      t.references :latest_post, null: true

      t.index :timestamp_id, unique: true
    end

    # Сначала добавляем nullable колонку
    add_reference :posts, :entry, null: true, foreign_key: { to_table: :post_entries }

    reversible do |dir|
      dir.up do
        # Создаем entries для существующих постов
        execute <<-SQL
          INSERT INTO post_entries (timestamp_id, user_id, latest_post_id)
          SELECT DISTINCT timestamp_id, user_id, id
          FROM posts
          WHERE parent_id IS NULL
        SQL

        # Связываем посты с их entries
        execute <<-SQL
          UPDATE posts
          SET entry_id = (
            SELECT post_entries.id
            FROM post_entries
            WHERE post_entries.timestamp_id = posts.timestamp_id
          )
        SQL

        # И только потом делаем колонку NOT NULL
        change_column_null :posts, :entry_id, false

        remove_column :posts, :timestamp_id
      end
    end
  end
end
