class AddIndexToPosts < ActiveRecord::Migration[5.0]
  def change
    add_index :posts, [:user_id, :created_at]
  end
end
