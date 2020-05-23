# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true

  # TODO: change third table name
  has_many :categories_stores, dependent: :destroy
  has_many :stores, through: :categories_stores
end
