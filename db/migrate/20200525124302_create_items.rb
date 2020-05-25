class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.float :price
      t.integer :quantity
      t.integer :store_id

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
