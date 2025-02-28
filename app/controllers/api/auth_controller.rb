module Api
  class AuthController < Api::ApplicationController
    skip_before_action :authenticate_user, only: [ :refresh_token ]

    def refresh_token
      user = User.find_by!(uuid: params[:uuid])

      # Создаём новый токен с более длительным временем жизни
      token = JWT.encode(
        {
          uuid: user.uuid,
          exp: 30.days.from_now.to_i  # Увеличиваем до 30 дней или другого подходящего срока
        },
        ENV["JWT_SECRET"] || Rails.application.credentials.jwt_secret,
        "HS256"
      )

      render json: { token: token }
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
