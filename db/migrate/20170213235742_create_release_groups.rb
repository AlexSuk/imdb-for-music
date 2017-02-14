class CreateReleaseGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :release_groups do |t|
      t.string :name
      t.string :record_label
      t.string :image_url

      t.timestamps
    end
  end
end
