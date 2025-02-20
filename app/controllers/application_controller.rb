class ApplicationController < ActionController::API
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def authenticate_user!
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find_by(auth_token: request.headers["Authorization"])
  end
end
