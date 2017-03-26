class RemovePostIdFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :post_id, :integer
  end
end
