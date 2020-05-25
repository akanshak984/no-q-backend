# frozen_string_literal: true

class Store < ApplicationRecord
  include Discard::Model

  validates :pincode, presence: true
  validates :address, presence: true
  validates :name, presence: true
  validates :opening_time, presence: true
  validates :closing_time, presence: true
  validates :duration, presence: true
  validates :available_days, length: { is: 7 }
  validates :code, uniqueness: true

  validate :closing_time?

  # TODO: change third table name
  has_many :categories_stores, dependent: :destroy
  has_many :categories, through: :categories_stores
  has_many :slots, dependent: :destroy
  belongs_to :user, optional: true

  self.discard_column = :deleted_at

  default_scope -> { kept }


  def closing_time?
    return if closing_time.in_time_zone.strftime('%H:%M') > opening_time.in_time_zone.strftime('%H:%M')

    errors.add(:base, 'Closing time should be greater than opening_time')
  end

  def set_code
    ([*('A'..'Z'), *('0'..'9')] - %w[0 1 I O]).sample(10).join
  end

  # rubocop:disable Metrics/AbcSize
  def proposed_slots
    time_slots = []
    close_time = Time.at(closing_time).utc
    (opening_time.to_datetime.to_i..closing_time.to_datetime.to_i).step(duration.minutes).each_with_index do |hour, index|
      time = {}
      start_time = Time.at(hour).utc
      step_time = (start_time + duration.minutes)
      time[:store_id] = id
      time[:sequence] = index + 1
      time[:from_time] = start_time.strftime('%H:%M')
      time[:to_time] = if step_time <= close_time
                         step_time.strftime('%H:%M')
                       else
                         close_time.strftime('%H:%M')
                       end
      time_slots << time
    end
    time_slots
  end

  def create_slots
    Slot.insert_all(proposed_slots)
  end
end
