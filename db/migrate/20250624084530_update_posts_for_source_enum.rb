class UpdatePostsForSourceEnum < ActiveRecord::Migration[7.1]
  def change
    remove_column :posts, :instagram_post, :boolean
    remove_column :posts, :instagram_post_id, :string

    add_column :posts, :source, :integer, default: 0, null: false
    add_column :posts, :external_id, :string
  end
end
