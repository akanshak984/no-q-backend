class AddUniqueIndexToStore < ActiveRecord::Migration[6.0]
  def change
    add_index :stores, :code, unique: :true
  end
end
