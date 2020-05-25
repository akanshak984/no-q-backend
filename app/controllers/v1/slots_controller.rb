# frozen_string_literal: true

module V1
  class SlotsController < BaseController
    skip_before_action :authenticate!, only: :index
    def index
      store_id = params[:store_id]
      @store = Store.find(store_id)
      current_time = Time.zone.now.in_time_zone('Asia/Kolkata')
      slots_over_current_time
      available_slots
      slots = fetch_todays_available_slots
      if current_time.strftime('%H:%M') >= (@store.closing_time - 1.hour).strftime('%H:%M') &&
         current_time.strftime('%H:%M') <= '23:59'
        render_json(
          message: I18n.t('list', model_name: 'Slot'),
          data: { todays_available_slot: serialize_resource(slots), tomorrows_slot: serialize_resource(fetch_next_days_slots) }
        )
      else
        render_json(
          message: I18n.t('list', model_name: 'Slot'),
          data: { todays_available_slot: serialize_resource(slots) }
        )
      end
    end

    def slots_over_current_time
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
        @available << x['slot_id'] unless x['count'] < @store.capacity
      end
    end

    def fetch_todays_available_slots
      columns =
        'slots.from_time, slots.to_time, slots.id, sequence, is_active'
      @response =
        Slot.where(id: @slot_ids - @available)
            .order('sequence asc')
            .select(columns)
    end

    def fetch_next_days_slots
      columns =
        'slots.from_time, slots.to_time, slots.id, sequence, is_active'
      Slot.where(store_id: @store.id, is_active: true)
          .order('sequence asc')
          .select(columns)
    end

    def mark
      slots = Slot.where(id: permitted_params[:ids])
      if slots.update(is_active: permitted_params[:is_active])
        render_json(
          message: I18n.t('updated.success', model_name: 'Slot'),
          data: serialize_resource(slots),
          status: :ok
        )
      else
        render_json(
          message: slots.errors.full_messages,
          status: :unprocessable_entity
        )
      end
    end

    private

    def permitted_params
      params.require(:slots).permit(:is_active, ids: [])
    end
  end
end
