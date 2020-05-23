# frozen_string_literal: true

class StoreSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :address, :city,
             :state, :pincode,
             :opening_time, :closing_time,
             :duration, :capacity, :available_days,
             :deleted_at, :slots, :categories

  has_many :categories
  has_many :slots

  def opening_time
    object.opening_time.strftime('%H:%M')
  end

  def closing_time
    object.closing_time.strftime('%H:%M')
  end
end
