# Human approved
module Api
  class UsersController < Api::ApplicationController
    skip_before_action :authenticate_user

    # POST http://dope.local:8080/register
    # Content-Type: application/json
    # Request body: {"nickname":"inem","port":34657,"uuid":"da561e9c-e1ad-4fd7-8cef-1b59888cafd5"}
    #
    # Пример ответа:
    # {
    #     "status": "registered",
    #     "uuid": "c3993f47-bad2-4fa0-9aea-3fa479ee847c",
    #     "token": "eyJhbGciOiJIUz..."
    # }
    def create
      uuid = params["uuid"]
      nickname = params["nickname"]
      port = params["port"]
      Rails.logger.info "Registering user with UUID: #{uuid}, nickname: #{nickname}, port: #{port}"

      user = UserService.register!(uuid, nickname, port)
      Current.user = user

      token = generate_jwt_token(user)

      response_data = {
        status: "registered",
        uuid: user.uuid,
        nickname: user.nickname,
        port: user.local_port,
        token: token
      }

      Rails.logger.info "Registration response: #{response_data.to_json}"
      render json: response_data
    rescue => e
      Rails.logger.error "Registration error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      Appsignal.send_error(e)
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def generate_jwt_token(user)
      JWT.encode(
        {
          uuid: user.uuid,
          exp: 24.hours.from_now.to_i
        },
        Rails.application.credentials.secret_key_base,
        "HS256"
      )
    end
  end
end
