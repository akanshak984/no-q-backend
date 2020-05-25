# frozen_string_literal: true

class Booking < ApplicationRecord
  belongs_to :store
  belongs_to :slot
  belongs_to :user, optional: true
end
