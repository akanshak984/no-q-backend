# frozen_string_literal: true
module V1
  class StoresController < V1::BaseController
    skip_before_action :authenticate!, only: [:index]

    def index
      if params[:pincode].present?
        query = "stores.pincode = ?"
        queryValue = [params[:pincode]]
        if params[:category_ids].present?
          query += "and categories.id in (?)"
          queryValue << params[:category_ids].split(',')
        end
        stores = Store.joins(:categories, "inner join categories_stores cs on cs.store_id = stores.id
                             inner join categories c on c.id = cs.category_id")
          .where(query, *queryValue)
          .select(:id, :name, :address, :pincode, :code, "array_to_string(array_agg( distinct c.name), ',') as category_names")
          .group("stores.id").distinct
        render_json(
          message: I18n.t('list', model_name: 'Stores'),
          data: stores, status: :ok
        )
      else
        render_json(
          message: I18n.t('store_list.pincode_blank'),
          status: :unprocessable_entity
        )
      end
    end

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

    def list
      @store = Store.where(user_id: current_user.id).first
      render_json(
          message: I18n.t('created.success', model_name: 'Store'),
          data: serialize_resource(@store),
          status: :ok
        )
    end

    private

    def permitted_params
      params.require(:store).permit(:name, :address, :pincode, :city, :state,
                                    :closing_time, :opening_time, :duration, :capacity, :available_days, category_ids: [])
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
          @store.update(code: @store.set_code, user_id: current_user.id) &&
          update_categories &&
          @store.create_slots
      end
    end
  end
end
