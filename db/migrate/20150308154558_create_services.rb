class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :description
      t.string :base_url
      t.boolean :is_public

      t.timestamps null: false
    end
  end
end
