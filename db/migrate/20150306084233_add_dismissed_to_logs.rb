class AddDismissedToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :dismissed, :boolean, default: :false
  end
end
