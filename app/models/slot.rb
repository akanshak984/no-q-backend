# frozen_string_literal: true

class Slot < ApplicationRecord
  belongs_to :store
  validates :store_id, presence: true
  validates :sequence, presence: true
  validates :from_time, presence: true
  validates :to_time, presence: true
end
