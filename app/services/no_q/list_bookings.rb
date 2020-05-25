# frozen_string_literal: true

module NoQ
  class ListBookings
    include ActiveModel::Validations

    def initialize(sequence:, message:, number:)
      @step = sequence.step
      @message = message
      @number = number
    end

    def call
      fetch_data &&
        check_present? &&
        generate_response &&
        set_message
    end

    def fetch_data
      @bookings =
        Booking.where('DATE(booking_date) = ? AND phone_number = ?',
                      Time.zone.now.in_time_zone('Asia/Kolkata').strftime('%Y-%m-%d'), @number)
    end

    def check_present?
      return true if @bookings.present?

      errors.add(:base, 'No Booking Available for today')
      false
    end

    # rubocop:disable Layout/LineLength
    # rubocop:disable Metrics/AbcSize
    def generate_response
      @msg = "Today's Booking Details:\n\n"
      @bookings.each do |book|
        slot = book.slot
        @msg +=
          "eToken: #{book.token}\n#{book.store.name} (#{book.store.address})\nDate: #{book.booking_date.to_date.to_s(:long_ordinal)}\nTime Slot: #{slot.from_time.in_time_zone.strftime('%H:%M')} - #{slot.to_time.in_time_zone.strftime('%H:%M')}\n\n"
      end
    end

    def set_message
      {
        success: true,
        message: @msg,
        sequence: @step,
        user_input: {
          key: 'list_bookings',
          value: @message
        }
      }
    end
  end
end
