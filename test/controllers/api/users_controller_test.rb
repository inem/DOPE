require "test_helper"

module Api
  class UsersControllerTest < ActionDispatch::IntegrationTest
    test "should register new user with custom nickname" do
      uuid = "c3993f47-bad2-4fa0-9aea-3fa479ee847c"
      nickname = "vin"
      request_body = { uuid: uuid, nickname: nickname }

      post api_users_path,
        params: request_body.to_json,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }

      assert_response :success
      assert_equal "application/json", @response.media_type

      response_data = JSON.parse(@response.body)
      assert_equal "registered", response_data["status"]
      assert_equal uuid, response_data["uuid"]
      assert_equal nickname, response_data["nickname"]
      assert_match(/^eyJhbGciOiJ/, response_data["token"])

      user = User.find_by(uuid: uuid)
      assert user.present?
      assert_equal nickname, user.nickname
      assert_equal "user-#{uuid[0..7]}@dope.local", user.email
    end

    test "should register new user with generated nickname" do
      uuid = "c3993f47-bad2-4fa0-9aea-3fa479ee847c"
      request_body = { uuid: uuid }

      post api_users_path,
        params: request_body.to_json,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }

      assert_response :success

      response_data = JSON.parse(@response.body)
      assert_equal "registered", response_data["status"]
      assert_equal uuid, response_data["uuid"]

      user = User.find_by(uuid: uuid)
      assert user.present?
      assert_equal response_data["nickname"], user.nickname
    end

    test "should validate nickname uniqueness" do
      # Создаем первого пользователя с никнеймом
      uuid1 = "c3993f47-bad2-4fa0-9aea-3fa479ee847c"
      nickname = "vin"
      UserService.register!(uuid1, nickname)

      # Пытаемся создать второго с тем же никнеймом
      uuid2 = "d4993f47-bad2-4fa0-9aea-3fa479ee847d"
      request_body = { uuid: uuid2, nickname: nickname }

      post api_users_path,
        params: request_body.to_json,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }

      assert_response :unprocessable_entity
      response_data = JSON.parse(@response.body)
      assert_includes response_data["error"], "Nickname has already been taken"
    end
  end
end
