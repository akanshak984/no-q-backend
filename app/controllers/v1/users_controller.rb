# frozen_string_literal: true

module V1
  class UsersController < BaseController
    skip_before_action :authenticate!, only: :create

    def index
      @users = User.all
      render_json(message: 'All users', data: @users)
    end

    def create
      @user = User.create(sign_up_params)
      if @user.save
        render_json(message: 'User created successfully', data: @user, status: :created)
      else
        render_json(message: 'Failure', data: @user.errors.full_messages, status: :unprocessable_entity)
      end
    end

    def sign_up_params
      params.require(:user).permit(:username, :password, :role_id)
    end
  end
end
