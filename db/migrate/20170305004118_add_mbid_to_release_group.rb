class AddMbidToReleaseGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :release_groups, :mbid, :string
  end
end
