class CreateInitialLogins < ActiveRecord::Migration[6.0]
  def change
    create_table :initial_logins do |t|
      t.references :user, index: { unique: true }, foreign_key: true
      t.timestamps
    end
  end
end
