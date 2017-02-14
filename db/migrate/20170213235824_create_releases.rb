class CreateReleases < ActiveRecord::Migration[5.0]
  def change
    create_table :releases do |t|
      t.string :name
      t.date :release_date
      t.string :country

      t.timestamps
    end
  end
end
