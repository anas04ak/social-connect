class CreateMentions < ActiveRecord::Migration[7.1]
  def change
    create_table :mentions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
