# frozen_string_literal: true

module NoQ
  class MarkComplete
    attr_reader :number

    def initialize(number:)
      @number = number
    end

    def call
      # destroy existing logs
      WhatsAppLog.where(phone_number: number).destroy_all
    end
  end
end
