# frozen_string_literal: true

module NoQ
  class ListCategories
    include ActiveModel::Validations

    def initialize(sequence:, message:, number:)
      @step = sequence.step
      @message = message
      @number = number
    end

    def call
      verify_pincode &&
        generate_response &&
        set_message
    end

    def verify_pincode
      @pincodes = Store.pluck(:pincode) &
                  @message.split.map(&:to_i)
      return true if @pincodes.present?

      errors.add(:base, 'Invalid Pincode/No Stores available')
      false
    end

    def generate_response
      @msg = "Choose the Category Code:\n\n"
      stores = Store.where(pincode: @pincodes)
      response = CategoriesStore.joins(:category).where(store_id: stores.ids).distinct.select('categories.code', 'categories.name').as_json
      response.each_with_index do |res, index|
        @msg += "#{index + 1}.#{res['name']} (Code: #{res['code']})\n"
      end
    end

    def set_message
      {
        success: true,
        message: @msg,
        sequence: @step,
        user_input: {
          key: 'pincode',
          value: @pincodes.join(',')
        }
      }
    end
  end
end
