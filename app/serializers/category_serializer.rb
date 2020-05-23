# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :code, :name
end
