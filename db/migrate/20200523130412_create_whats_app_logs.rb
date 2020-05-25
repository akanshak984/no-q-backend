class CreateWhatsAppLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :whats_app_logs do |t|
      t.string :sequence
      t.string :status
      t.string :error_message
      t.bigint :phone_number
      t.string :message_type

      t.timestamps
    end
  end
end
