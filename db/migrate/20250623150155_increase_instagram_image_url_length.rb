class IncreaseInstagramImageUrlLength < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :instagram_image_url, :string, limit: 1000
  end
end
