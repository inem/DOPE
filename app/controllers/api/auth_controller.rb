module Api
  class AuthController < Api::ApplicationController
    skip_before_action :authenticate_user, only: [ :refresh_token ]

    def refresh_token
      user = User.find_by!(uuid: params[:uuid])
      token = JwtHandler.generate(user)
      render json: { token: token }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
