class CreateSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :slots do |t|
      t.belongs_to :store
      t.integer :sequence
      t.time :from_time
      t.time :to_time
      t.boolean :is_active
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
