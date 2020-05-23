# frozen_string_literal: true

module V1
  class CategoriesController < V1::BaseController
    skip_before_action :authenticate!

    def index
      render_json(
        message: I18n.t('list', model_name: 'Categories'),
        data: serialize_resource(Category.all)
      )
    end
  end
end
