class AddArtistToRelease < ActiveRecord::Migration[5.0]
  def change
    add_column :releases, :artist_id, :integer
  end
end
