class FixCommentTextName < ActiveRecord::Migration[5.0]
  def change
    rename_column :posts, :comment, :body
  end
end
