module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_user

    private

    def authenticate_user
      header = request.headers["Authorization"]
      if !header || !header.start_with?("Bearer ")
        Rails.logger.warn "No valid Authorization header found"
        return render json: {
          error: "Authentication required",
          code: "auth_required"
        }, status: :unauthorized
      end

      begin
        token = header.split(" ").last
        payload = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: "HS256").first
        Current.user = User.find_by(uuid: payload["uuid"])
      rescue JWT::ExpiredSignature
        return render json: {
          error: "Token has expired",
          code: "token_expired"
        }, status: :unauthorized
      rescue JWT::DecodeError
        return render json: {
          error: "Invalid token",
          code: "invalid_token"
        }, status: :unauthorized
      end

      if !Current.user
        Rails.logger.warn "User not found for token payload: #{payload.inspect}"
        return render json: {
          error: "User not found",
          code: "user_not_found"
        }, status: :unauthorized
      end

      Rails.logger.info "User authenticated: #{Current.user.uuid}"
    end
  end
end
