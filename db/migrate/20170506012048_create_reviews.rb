class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.string :m_category
      t.string :link
      t.string :name
      t.integer :rating
      t.text :review

      t.timestamps
    end
  end
end
