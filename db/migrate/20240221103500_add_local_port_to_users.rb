class AddLocalPortToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :local_port, :integer
  end
end
