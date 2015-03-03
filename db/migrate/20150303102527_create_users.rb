class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail
      t.string :roles
      t.string :image
      t.integer :siso_uid
      t.integer :siso_gid
      t.boolean :siso_active
      t.datetime :last_seen

      t.timestamps null: false
    end
  end
end
