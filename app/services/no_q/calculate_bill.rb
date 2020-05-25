# frozen_string_literal: true

module NoQ
  class CalculateBill
    include ActiveModel::Validations

    attr_reader :step

    def initialize(sequence:, number:, message:)
      @step = sequence.step
      @number = number
      @message = message.downcase.split.map(&:to_s)
    end

    def call
      last_booking &&
      check_items &&
       generate_response &&        
       set_message
    end

    def last_booking
      booking_id = WhatsAppLog.where(phone_number: @number).order('sequence desc').first.user_input['value']
      @booking = Booking.find_by(id: booking_id)
    end

    def check_items
      @items = Item.all.pluck(:name) &
               @message
      return true if @items.present?

      errors.add(:base, 'Items not available')
      false
    end

    def generate_response
      slot = @booking.slot
      amount = Item.where(name: @items)
                   .pluck(:price).sum
      @msg =
        "eToken: #{@booking.token}\n#{@booking.store.name}\nOrder Confirmed\nAmount: #{amount} \nPick-up Date: #{@booking.booking_date.to_date.to_s(:long_ordinal)}\nTime Slot: #{slot.from_time.in_time_zone.strftime('%H:%M')} - #{slot.to_time.in_time_zone.strftime('%H:%M')}"
    end

    def set_message
      {
        success: true,
        message: @msg,
        sequence: step
      }
    end
  end
end
