# frozen_string_literal: true

module NoQ
  class EnterPincode
    attr_reader :step

    def initialize(sequence:, number:)
      @step = sequence.step
      @number = number
    end

    def call
      WhatsAppLog.where(phone_number: @number).destroy_all
      {
        success: true,
        message: I18n.t('whatsapp.initiate'),
        sequence: step
      }
    end
  end
end
