# frozen_string_literal: true

module V1
  class SessionsController < V1::BaseController
    skip_before_action :authenticate!
    before_action :validate_params, only: [:create]
    before_action :find_user, only: [:create]

    def create
      if @user.authenticate(permitted_params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        store = Store.find_by(user_id: @user.id)
        render_json(
          message: I18n.t('login.success'),
          data: { auth_token: token, store_registered: store.present?, store_id: store&.id, is_admin: @user.is_admin? },
          status: :ok
        )
      else
        render_json(
          message: I18n.t('login.failure'),
          status: :unauthorized
        )
      end
    end

    private

    def permitted_params
      params.require(:user).permit(:username, :password)
    end

    def validate_params
      return true if permitted_params[:username] &&
                     permitted_params[:password]

      render_json(
        message: I18n.t('user.parameters'),
        status: :unauthorized
      )
    end

    def find_user
      @user = User.find_by(username: permitted_params[:username])
      return true if @user

      render_json(
        message: I18n.t('errors.record', model_name: 'User'),
        status: :unauthorized
      )
    end
  end
end
