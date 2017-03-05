class AddArtistToReleaseGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :release_groups, :artist_id, :integer
  end
end
