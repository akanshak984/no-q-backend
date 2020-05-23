# frozen_string_literal: true

class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, ENV['SECRET_KEY_BASE'])
    rescue StandardError
      nil
    end

    def decode(token)
      body = JWT.decode(token, ENV['SECRET_KEY_BASE'])[0]
      HashWithIndifferentAccess.new body
    rescue StandardError
      nil
    end

    def valid_payload(payload)
      if expired(payload)
        false
      else
        true
      end
      true
    end

    def expired(payload)
      Time.zone.at(payload[:exp]) < Time.zone.now
    end
  end
end
