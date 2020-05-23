class AddDefaultValueToIsActiveColumn < ActiveRecord::Migration[6.0]
  def change
    change_column_default :slots, :is_active, true
  end
end
