class DropTracks < ActiveRecord::Migration[5.0]
  def up
    drop_table :tracks
  end

  def down
    create_table :release_groups do |t|
      t.string :name
      t.integer :release_id

      t.timestamps
    end
  end
end
