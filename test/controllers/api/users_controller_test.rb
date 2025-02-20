require "test_helper"

module Api
  class UsersControllerTest < ActionDispatch::IntegrationTest
    test "should register new user" do
      # Подготавливаем данные запроса
      uuid = "c3993f47-bad2-4fa0-9aea-3fa479ee847c"
      request_body = { uuid: uuid }

      # Отправляем POST запрос
      post api_users_path,
        params: request_body.to_json,
        headers: { "Content-Type": "application/json" }

      # Проверяем успешный ответ
      assert_response :success
      assert_equal "application/json", @response.media_type

      # Проверяем формат ответа
      response_data = JSON.parse(@response.body)
      assert_equal "registered", response_data["status"]
      assert_equal uuid, response_data["uuid"]
      assert_match(/^eyJhbGciOiJ/, response_data["token"], "JWT token should start with eyJhbGciOiJ")

      # Проверяем создание пользователя
      user = User.find_by(uuid: uuid)
      assert user.present?
      assert_equal "user-#{uuid[0..7]}@dope.local", user.email

      # Проверяем что токен действительно JWT
      token_data = JWT.decode(
        response_data["token"],
        Rails.application.credentials.secret_key_base,
        true,
        algorithm: "HS256"
      ).first

      assert_equal uuid, token_data["uuid"]
      assert token_data["exp"] > Time.now.to_i
    end
  end
end
