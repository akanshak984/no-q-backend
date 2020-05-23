class CreateJoinTableStoreCategory < ActiveRecord::Migration[6.0]
  def change
    create_join_table :stores, :categories do |t|
      t.index [:category_id, :store_id]
    end
  end
end
