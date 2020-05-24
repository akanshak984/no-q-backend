class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.belongs_to :user
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :code
      t.integer :pincode
      t.time :opening_time
      t.time :closing_time
      t.integer :duration
      t.integer :capacity
      t.bit :available_days, limit: 7
      t.datetime :deleted_at

      t.timestamps
    end
  end
end