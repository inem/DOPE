module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_user

    private

    def authenticate_user
      header = request.headers["Authorization"]

      if !header || !header.start_with?("Bearer ")
        Rails.logger.warn "No valid Authorization header found"
        return render json: { error: "No valid token provided" }, status: :unauthorized
      end

      Current.user = User.find_by(uuid: JwtToken.extract_uuid(header))

      if !Current.user
        Rails.logger.warn "User not found for UUID: #{Current.user.uuid}"
        return render json: { error: "User not found" }, status: :unauthorized
      end

      Rails.logger.info "User authenticated: #{Current.user.uuid}"
    end
  end
end
