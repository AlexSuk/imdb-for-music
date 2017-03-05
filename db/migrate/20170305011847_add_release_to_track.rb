class AddReleaseToTrack < ActiveRecord::Migration[5.0]
  def change
    add_column :tracks, :release_id, :integer
  end
end
