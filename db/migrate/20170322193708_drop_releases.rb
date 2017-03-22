class DropReleases < ActiveRecord::Migration[5.0]
  def up
    drop_table :releases
  end

  def down
    create_table :release_groups do |t|
      t.string :name
      t.date :release_date
      t.string :country
      t.integer :artist_id
      t.integer :release_group_id
      t.string :mbid

      t.timestamps
    end
  end
end
