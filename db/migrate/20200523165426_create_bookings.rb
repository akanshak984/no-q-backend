class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.integer :store_id
      t.string :mode
      t.string :token
      t.bigint :phone_number
      t.datetime :booking_date
      t.integer :slot_id

      t.timestamps
    end
  end
end
