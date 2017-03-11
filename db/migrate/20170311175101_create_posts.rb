class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.integer :user_id
      t.integer :artist_id
      t.integer :track_id
      t.integer :release_id
      t.integer :releasegroup_id
      t.integer :post_id
      t.text :comment

      t.timestamps
    end
  end
end
