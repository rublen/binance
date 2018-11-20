class Credentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.string :key, null: false
      t.string :secret, null: false

      t.timestamps
    end
  end
end
