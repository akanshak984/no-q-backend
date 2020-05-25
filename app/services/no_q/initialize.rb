# frozen_string_literal: true
module NoQ
  class Initialize
    def initialize(config:, params: {})
      @url = URI('https://api.gupshup.io/sm/api/v1/msg')
      @config = config
      @number = params['payload']['source']
      @message = params['payload']['payload']['text']
      @message_type = params['payload']['type']
      @user_name = params['payload']['sender']['name']
      @image_path = params['payload']['payload']['url']

      # TO TEST
      # @number = '918600160602'
      # @message = 'rice dal'
      # @message_type = 'text'
    end

    def call
      last_sequence &&
        calculate_step &&
        initiate_chat &&
        apply_rule &&
        set_fail_message &&
        set_success_message &&
        send_message
    end

    def last_sequence
      @last = WhatsAppLog.where(phone_number: @number).order('sequence desc').pluck(:sequence)
    end

    def calculate_step
      if @message == 'MY BOOKINGS'
        @sequence = @config.send('sequence_7')
      elsif @last.present?
        @next = @last.first.to_i + 1
        next_sequence = "sequence_#{@next}"
        @sequence = @config.send(next_sequence)
      else
        @sequence = @config.send('sequence_1')
      end
    end

    def initiate_chat
      return false if @message_type != 'text'

      case @sequence.message_category
      when 'pincode'
        @result =
          NoQ::EnterPincode.new(
            sequence: @sequence,
            number: @number
          ).call
      else
        true
      end
      true
    end

    def apply_rule
      return true if @result

      clazz = Object.const_get("NoQ::#{@sequence.method_name}")
      case @sequence.message_category
      when 'categories_under_pincode',
           'shops_under_categories',
           'available_slots_under_shops',
           'generate_token', 'my_bookings',
           'calculate_bill'
        @obj =
          clazz.new(
            sequence: @sequence,
            message: @message,
            number: @number
          )
        @result = @obj.call
      else
        true
      end
      true
    end

    def set_fail_message
      return true if @obj&.errors.blank?

      @reply = @obj.errors.full_messages.join(',')
      NoQ::MarkComplete.new(number: @number).call
    end

    def set_success_message
      return true if @reply

      @reply = @result[:message]
      @success = true
    end

    def send_message
      return true unless @reply

      Rails.logger.info @reply

      Whatsapp::SendMessage.new(
        number: @number,
        message: @reply,
        sequence: @sequence,
        success: @success,
        message_type: @message_type,
        user_input: (@result && @result[:user_input]) || nil
      ).call

      NoQ::MarkComplete.new(number: @number).call if @sequence&.last
    end
  end
end
