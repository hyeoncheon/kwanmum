class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.string :description
      t.references :client, polymorphic: true, index: true
      t.references :service, index: true
      t.text :permissions

      t.timestamps null: false
    end
    add_foreign_key :accesses, :services
  end
end
