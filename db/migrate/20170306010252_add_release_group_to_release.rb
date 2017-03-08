class AddReleaseGroupToRelease < ActiveRecord::Migration[5.0]
  def change
    add_column :releases, :releasegroup_id, :integer
  end
end
