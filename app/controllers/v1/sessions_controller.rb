# frozen_string_literal: true

module V1
  class SessionsController < V1::BaseController
    skip_before_action :authenticate!

    def create; end

    private

    def permitted_params
      params.require(:user).permit(:username, :password)
    end
  end
end
