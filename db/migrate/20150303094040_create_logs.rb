class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :category
      t.string :level
      t.datetime :time
      t.string :service
      t.string :hostname
      t.string :process
      t.string :message
      t.string :actor
      t.string :action
      t.string :target
      t.string :reason
      t.string :tag
      t.references :client, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
