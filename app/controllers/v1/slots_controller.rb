# frozen_string_literal: true

module V1
  class SlotsController < BaseController
    # to create slots authentication is required
    skip_before_action :authenticate!, only: [:index]

    def index
      slots = Slot.all
      render_json(
        message: I18n.t('list', model_name: 'Slot'),
        data: slots
      )
    end

    def create
      store_id = slot_params[:id]
      slots = slot_params[:slots]
      params = { store_id: store_id, slots: slots }
      create_bulk_params(params)

      if save_record
        render_json(
          message: I18n.t('created.success', model_name: 'Slot'),
          data: serialize_resource(@slot), status: :created
        )
      else
        render_json(
          message: @slot.errors.full_messages,
          status: :unprocessable_entity
        )
      end
    end

    def create_bulk_params(params)
      store_id = params[:store_id]
      slots = params[:slots]
      @params_for_bulk_creation = []
      slots.each do |slot|
        current_slot = {}
        @params_for_bulk_creation << current_slot.merge!(store_id: store_id,
                                                         sequence: slot['sequence'],
                                                         from_time: slot['from_time'],
                                                         to_time: slot['to_time'],
                                                         is_active: slot['is_active'])
      end
    end

    private

    def slot_params
      params.require(:store).permit(:id, slots: %i[sequence
                                                   from_time to_time is_active])
    end

    def save_record
      ActiveRecord::Base.transaction do
        @slot = Slot.insert_all(
          @params_for_bulk_creation,
          returning: %w[id store_id sequence from_time to_time is_active]
        )
      end
    end
  end
end
