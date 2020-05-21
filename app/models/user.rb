# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { in: 4..15 }

  enum roles: { shop_owner: 1 }

  def role
    User.roles.key(role_id)
  end

  def shop_owner?
    role == 'shop_owner'
  end
end
