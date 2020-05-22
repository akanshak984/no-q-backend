class CreateSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :slots do |t|
      t.belongs_to :store
      t.time :from_time
      t.time :to_time
      t.boolean :is_active
      t.timestamps
    end
  end
end
