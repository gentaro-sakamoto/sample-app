class CreateActivityNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_notifications do |t|
      t.references :activity, index: true
      t.references :recipient, index: true

      t.timestamps
    end
  end
end
