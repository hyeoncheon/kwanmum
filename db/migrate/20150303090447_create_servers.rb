class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :uuid
      t.string :hostname
      t.string :address
      t.string :description
      t.string :api_key

      t.timestamps null: false
    end
    add_index :servers, :uuid, unique: true
    add_index :servers, :api_key, unique: true
  end
end
