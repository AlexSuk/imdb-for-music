class DropArtists < ActiveRecord::Migration[5.0]
  def up
    drop_table :artists
  end

  def down
    create_table :artists do |t|
      t.string :name
      t.string :mbid
      t.group_type :string
      t.image_url :string
      t.country :string
      t.date_started :date
      t.date_ended :date

      t.timestamps
    end
  end
end
