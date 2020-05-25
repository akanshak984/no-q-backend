# frozen_string_literal: true

module NoQ
  class GenerateToken
    include ActiveModel::Validations

    def initialize(sequence:, message:, number:)
      @step = sequence.step
      @slot_id = message.split.map(&:to_i)
      @number = number
    end

    def call
      verify_slot &&
        book_slot &&
        generate_response &&
        set_message
    end

    def verify_slot
      @slot_id =
        Slot.pluck(:id) &
        @slot_id
      @slot = Slot.where(id: @slot_id).first
      return true if @slot.present?

      errors.add(:base, 'Invalid Slot ID')
      false
    end

    def book_slot
      @booking =
        Booking.create(
          store_id: @slot.store.id,
          slot_id: @slot.id,
          mode: 'Whatsapp',
          token: random_token,
          booking_date: Time.zone.now.in_time_zone('Asia/Kolkata'),
          phone_number: @number
        )
    end

    # rubocop:disable Layout/LineLength
    # rubocop:disable Metrics/AbcSize
    def generate_response
      slot = @booking.slot
      @msg = "Booking Details:\n\n"
      @msg +=
        "eToken: #{@booking.token}\n#{@booking.store.name} (#{@booking.store.address})\nDate: #{@booking.booking_date.to_date.to_s(:long_ordinal)}\nTime Slot: #{slot.from_time.in_time_zone.strftime('%H:%M')} - #{slot.to_time.in_time_zone.strftime('%H:%M')}\nList your items"
    end

    def set_message
      {
        success: true,
        message: @msg,
        sequence: @step,
        user_input: {
          key: 'booking_id',
          value: @booking.id
        }
      }
    end

    private

    def random_token
      ([*('A'..'Z'), *('0'..'9')] - %w[0 1 I O]).sample(8).join
    end
  end
end
