class AddNameToFavorites < ActiveRecord::Migration[5.0]
  def change
    add_column :favorites, :name, :string
  end
end
