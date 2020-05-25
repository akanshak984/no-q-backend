# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :store
  belongs_to :slot
end
