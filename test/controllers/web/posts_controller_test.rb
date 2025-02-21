require "test_helper"

module Web
  class PostsControllerTest < ActionDispatch::IntegrationTest
    test "should show latest version of post" do
      user = User.create!(
        email: "test@example.com",
        password: "password",
        nickname: "tester",
        uuid: SecureRandom.uuid
      )

      # Создаем оригинальный пост
      original_post = Post.create!(
        user: user,
        content: "# Original Post\n\nContent",
        uuid: SecureRandom.uuid,
        timestamp_id: Time.current.strftime("%Y%m%d%H%M%S"),
        version: 1,
        latest: false
      )

      # Создаем новую версию
      updated_post = Post.create!(
        user: user,
        content: "# Updated Post\n\nContent",
        uuid: SecureRandom.uuid,
        parent_id: original_post.id,
        version: 2,
        latest: true,
        similarity: 0.8
      )

      get latest_post_path(nickname: user.nickname, timestamp_id: original_post.timestamp_id)
      assert_response :success
      assert_select "h2", "Updated Post"
      assert_select ".similarity", "(80.0% similar)"
    end

    test "should return 404 for non-existent timestamp_id" do
      user = User.create!(
        email: "test@example.com",
        password: "password",
        nickname: "tester",
        uuid: SecureRandom.uuid
      )

      get latest_post_path(nickname: user.nickname, timestamp_id: "nonexistent")
      assert_response :not_found
    end

    test "should return 404 for non-existent user" do
      get latest_post_path(nickname: "nonexistent", timestamp_id: "any")
      assert_response :not_found
    end

    test "should show post content for local user" do
      user = User.create!(
        email: "test@example.com",
        password: "password",
        nickname: "tester",
        uuid: SecureRandom.uuid
      )

      post = Post.create!(
        user: user,
        content: "# Test Post\n\nContent",
        uuid: SecureRandom.uuid,
        timestamp_id: Time.current.strftime("%Y%m%d%H%M%S"),
        version: 1,
        latest: true
      )

      get post_content_path(user.uuid, post.uuid)
      assert_response :success
      assert_equal "text/plain", response.media_type
    end
  end
end
