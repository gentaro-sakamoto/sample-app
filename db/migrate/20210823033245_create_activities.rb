class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.references :actable, index: { unique: true }, polymorphic: true
      t.integer :parent_id

      t.timestamps
    end
  end
end
