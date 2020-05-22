# frozen_string_literal: true

class Category < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true
end
