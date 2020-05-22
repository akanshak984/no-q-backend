# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true

  has_and_belongs_to_many :stores
end
