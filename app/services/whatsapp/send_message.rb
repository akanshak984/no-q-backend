# frozen_string_literal: true

require 'uri'
require 'net/http'
module Whatsapp
  class SendMessage
    def initialize(number:, message:, sequence:, success:, message_type:, user_input:)
      @url = URI('https://api.gupshup.io/sm/api/v1/msg')
      @number = number
      @message = message
      @sequence = sequence.step
      @success = success
      @message_type = message_type
      @user_input = user_input
    end

    def call
      response = make_request
      Rails.logger.info JSON.parse(response.body)
      log_message(JSON.parse(response.body)) if @success
    end

    def log_message(response)
      WhatsAppLog.create(
        status: response['status'],
        sequence: @sequence,
        phone_number: @number,
        error_message: response['message'],
        message_type: @message_type,
        user_input: @user_input
      )
    end

    def make_request
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(@url)
      request['apikey'] = '489d73b4836c4f22cf50f728277ac783'
      request.body = 'channel=whatsapp&source=917834811114&destination=' + @number + '&message=' + @message + '&src.name=ShopTok'

      http.request(request)
    end
  end
end
