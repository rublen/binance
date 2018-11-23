class Credentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.string :api_key, null: false, unique: true
      t.string :api_secret, null: false, unique: true

      t.timestamps
    end
  end
end
