class AddUserInputToWhatsAppLog < ActiveRecord::Migration[6.0]
  def change
    add_column :whats_app_logs, :user_input, :json
  end
end
