# frozen_string_literal: true

module V1
  class AdminController < V1::BaseController
    def stores
      stores = Store.unscoped.joins("inner join categories_stores cs on cs.store_id = stores.id
                              inner join categories c on c.id = cs.category_id")
        .select(:id, :name, :address, :pincode, :duration, :code, :deleted_at,
                "array_to_string(array_agg( distinct c.name), ',') as category_names")
        .group("stores.id").distinct
      render_json(
        message: I18n.t('list', model_name: 'Stores'),
        data: stores, status: :ok
      )
    end

    def disable_store
      #TODO check existing bookings and give warning
      store = Store.find_by id: params[:id]
      store.discard if store.present?
    end
  end
end

