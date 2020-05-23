# frozen_string_literal: true

module V1
  class StoresController < V1::BaseController

    def create
      @store = Store.new(permitted_params.except(:category_ids))
      if save_recod
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
      params.require(:store).permit(:name, :address, :pincode, :city, :state, :closing_time, :opening_time, :duration, :capacity, :available_days, category_ids: [])
    end

    def update_categories
      permitted_params[:category_ids].each do |id|
        category = Category.find_by(id: id)
        @store.categories << category if category
      end
    end

    def save_recod
      ActiveRecord::Base.transaction do
        @store.save &&
          @store.update(code: @store.code) &&
          update_categories &&
          @store.create_slots
      end
    end
  end
end
