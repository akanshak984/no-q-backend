# frozen_string_literal: true

module V1
  class BaseController < ApplicationController
    before_action :authenticate!

    attr_reader :current_user

    def render_json(message:, data: {}, status: :ok)
      render(json: { message: message, data: data }, status: status)
    end

    def validate_jwt_token!
      @payload = JsonWebToken.decode(@token)
      return true if @payload

      token_invalid
    end

    def authenticate!
      header_present? &&
        validate_jwt_token! &&
        load_current_user!
    end

    def token_invalid
      render_json(
        message: I18n.t('session.invalid'),
        status: :unauthorized
      ) and return
    end

    def not_found
      render_json(
        message: I18n.t('errors.record', model_name: 'User'),
        status: :unauthorized
      ) and return
    end

    def load_current_user!
      @current_user = User.find_by(id: @payload['user_id'])
      return if @current_user

      not_found
    end

    def header_present?
      @token = request.headers['Authorization']
      return true if @token

      render_json(
        message: I18n.t('session.header_missing'),
        status: :unauthorized
      ) and return
    end

    def serialize_resource(resource, opts = {})
      ActiveModelSerializers::SerializableResource.new(resource, opts)
    end
  end
end
