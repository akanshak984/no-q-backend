# frozen_string_literal: true

module NoQ
  class ListSlots
    include ActiveModel::Validations

    attr_reader :step, :store

    def initialize(sequence:, message:, number:)
      @step = sequence.step
      @user_code = message.split.map(&:to_s)
      @number = number
    end

    def call
      last_sequence &&
        verify_store &&
        verify_user &&
        slots_over_current_time &&
        available_slots &&
        fetch_slots &&
        check_response &&
        generate_response &&
        set_message
    end

    def last_sequence
      @last = WhatsAppLog.where(phone_number: @number).where(sequence: [step - 2, step - 1]).order('sequence desc').pluck(:user_input)
    end

    # rubocop:disable Metrics/AbcSize
    def verify_store
      where_clause = create_sql + "stores.code ilike '#{@user_code.join(',')}%'"
      @store = Store.joins(:categories)
                    .where(where_clause)
                    .first
      return true if @store.present?

      errors.add(:base, 'Invalid Store Code')
      false
    end

    def verify_user
      date = Time.zone.now.in_time_zone('Asia/Kolkata').strftime('%Y-%m-%d')
      time = Time.zone.now.in_time_zone('Asia/Kolkata').strftime('%H:%M')
      earlier =
        Booking.joins(:slot)
               .where('DATE(bookings.booking_date) = ? AND phone_number = ? AND bookings.store_id = ?', date,
                      @number, @store.id)
               .select("to_char(slots.to_time, 'HH24:MI') as to_time").as_json
      result = []
      earlier.select do |x|
        result << x['to_time'] if time.to_s < x['to_time']
      end
      return true if result.blank?

      errors.add(:base, 'You already have a booking with this store, next booking can be made once the previous slot time has passed')
      false
    end

    def slots_over_current_time
      # byebug
      time = Time.zone.now.in_time_zone('Asia/Kolkata').strftime('%H:%M')
      select_clause = "id, to_char(slots.from_time, 'HH24:MI') as last_time"
      @slot_ids =
        Slot.where(store_id: @store.id, is_active: true)
            .select(select_clause)
            .as_json
            .select do |x|
              x['last_time'] >= time.to_s
            end
            .pluck('id')
    end

    def available_slots
      @available = []
      bookings =
        Booking.where(slot_id: @slot_ids)
               .where('DATE(booking_date) = ?', Time.zone.now.in_time_zone('Asia/Kolkata').strftime('%Y-%m-%d'))
               .select('slot_id, count(slot_id)')
               .group(:slot_id).as_json
      bookings.select do |x|
        @available << x['slot_id'] unless x['count'] < store.capacity
      end
    end

    def fetch_slots
      columns =
        'slots.from_time, slots.to_time,slots.id'
      @response =
        Slot.where(id: @slot_ids - @available)
            .order('sequence asc')
            .select(columns)
            .as_json
    end

    def check_response
      return true if @response.present?

      errors.add(:base, 'No Slots are available now, Please check tomorrow!')
      false
    end

    def generate_response
      @msg = "Choose ID of the Time Slot:\n\n"
      @response.each_with_index do |res, index|
        @msg += "#{index + 1}. #{res['from_time'].in_time_zone.strftime('%H:%M')} - #{res['to_time'].in_time_zone.strftime('%H:%M')} (ID: #{res['id']})\n"
      end
    end

    def set_message
      {
        success: true,
        message: @msg,
        sequence: step,
        user_input: {
          key: 'store_code',
          value: @user_code.join(',')
        }
      }
    end

    private

    def create_sql
      sql = ''
      @last.each do |l|
        case l['key']
        when 'pincode'
          sql += "stores.pincode = '#{l['value']}' AND "
        when 'category_code'
          sql += "categories.code = '#{l['value']}' AND "
        else
          sql
        end
      end
      sql
    end
  end
end
