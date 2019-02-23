class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :thumbnail_url
      t.string :product_url
      t.integer :team_id
      t.integer :likes
      t.timestamps null: false
    end
  end
end
