# frozen_string_literal: true

module NoQ
  class ListShops
    include ActiveModel::Validations

    attr_reader :step, :user_code

    def initialize(sequence:, message:, number:)
      @step = sequence.step
      @user_code = message.split.map(&:to_s)
      @number = number
    end

    def call
      last_sequence &&
        verify_category &&
        fetch_data &&
        generate_response &&
        set_message
    end

    def last_sequence
      @last = WhatsAppLog.where(phone_number: @number).order('sequence desc').first
    end

    def verify_category
      @user_code = Category.pluck(:code) &
                   user_code
      return true if user_code.present?

      errors.add(:base, 'Invalid Category Code')
      false
    end

    def fetch_data
      @msg = "Enter the First 3 character of Store Code:\n\n"
      where_clause = "categories.code IN ('#{user_code.join(',')}') AND stores.pincode = #{@last.user_input['value']}"
      @response =
        Store.joins(:categories)
             .where(where_clause)
             .select('stores.code as store_code', 'stores.name as store_name',
                     'stores.address as addr')
             .as_json

      return true if @response.present?

      errors.add(:base, 'No Stores Available')
      false
    end

    def generate_response
      @response.each_with_index do |res, index|
        @msg += "#{index + 1}.#{res['store_name']} (Code: #{res['store_code']})\n  #{res['addr']}\n"
      end
    end

    def set_message
      {
        success: true,
        message: @msg,
        sequence: step,
        user_input: {
          key: 'category_code',
          value: @user_code.join(',')
        }
      }
    end
  end
end
