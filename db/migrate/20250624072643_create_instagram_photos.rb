class CreateInstagramPhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :instagram_photos do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
