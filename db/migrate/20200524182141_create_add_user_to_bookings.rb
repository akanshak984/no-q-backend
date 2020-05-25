class CreateAddUserToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :bookings, :user_id, :bigint
  end
end
