# frozen_string_literal: true

module V1
  class StoresController < V1::BaseController
    skip_before_action :authenticate!, only: [:create]

    def create
      @store = Store.new(permitted_params)
      if @store.save && @store.update(code: @store.code)
        render_json(
          message: I18n.t('created.success', model_name: 'Store'),
          data: serialize_resource(@store),
          status: :ok
        )
      else
        render_json(
          message: @store.errors.full_messages,
          status: :unprocessable_entity
        )
      end
    end

    private

    def permitted_params
      params.require(:store).permit(:name, :address, :pincode, :city, :state, :closing_time, :opening_time, :duration, :capacity, :available_days)
    end
  end
end
