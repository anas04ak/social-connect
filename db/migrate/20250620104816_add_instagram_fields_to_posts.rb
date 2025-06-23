class AddInstagramFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :instagram_post, :boolean
    add_column :posts, :instagram_post_id, :string
  end
end
