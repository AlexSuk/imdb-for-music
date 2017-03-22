class DropReleaseGroups < ActiveRecord::Migration[5.0]
  def up
    drop_table :release_groups
  end

  def down
    create_table :release_groups do |t|
      t.string :name
      t.string :record_label
      t.string :image_url
      t.integer :artist_id
      t.string :mbid

      t.timestamps
    end
  end
end
