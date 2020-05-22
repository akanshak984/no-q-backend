# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :role_id, :auth_token, :role

  def auth_token
    JsonWebToken.encode(user_id: object.id)
  end

  def role
    object.role
  end
end
