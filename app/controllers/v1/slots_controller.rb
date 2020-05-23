# frozen_string_literal: true

module V1
  class SlotsController < BaseController
    def index
      slots = Slot.all # where(is_active: true)
      render_json(
        message: I18n.t('list', model_name: 'Slot'),
        data: serialize_resource(slots)
      )
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
