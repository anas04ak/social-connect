class AddInstagramFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :instagram_username, :string
    add_column :users, :instagram_image_url, :string
  end
end
