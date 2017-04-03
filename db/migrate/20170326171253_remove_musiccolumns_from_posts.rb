class RemoveMusiccolumnsFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :artist_id, :integer
    remove_column :posts, :track_id, :integer
    remove_column :posts, :releasegroup_id, :integer
    remove_column :posts, :release_id, :integer
  end
end
