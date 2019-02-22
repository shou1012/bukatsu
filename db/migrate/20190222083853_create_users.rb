class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :profile_url
      t.string :email
      t.string :password_digest
      t.text :profile#プロフィール詳細
      t.timestamps null: :false
    end
  end
end
