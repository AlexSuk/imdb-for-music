class AddMbidToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :mbid, :string
  end
end
