# frozen_string_literal: true

class Store < ApplicationRecord
  validates :pincode, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :opening_time, presence: true
  validates :closing_time, presence: true
  validates :duration, presence: true
  validates :available_days, length: { is: 7 }
  validates :code, uniqueness: true

  validate :closing_time?

  def closing_time?
    return if closing_time.in_time_zone.strftime('%H:%M') > opening_time.in_time_zone.strftime('%H:%M')

    errors.add(:base, 'Closing time should be greater than opening_time')
  end

  def code
    rand(36**10).to_s(36)
  end
end
