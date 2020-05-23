# frozen_string_literal: true

class SlotSerializer < ActiveModel::Serializer
  attributes :id, :sequence, :from_time,
             :to_time, :is_active

  def from_time
    object.from_time.strftime('%H:%M')
  end

  # TODO: change column name to_time is ruby method
  # rubocop:disable Rails/Date
  def to_time
    object.to_time.strftime('%H:%M')
  end
end
