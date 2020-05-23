# frozen_string_literal: true

class CategoriesStore < ApplicationRecord
  belongs_to :store
  belongs_to :category
end
