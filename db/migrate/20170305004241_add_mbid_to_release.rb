class AddMbidToRelease < ActiveRecord::Migration[5.0]
  def change
    add_column :releases, :mbid, :string
  end
end
