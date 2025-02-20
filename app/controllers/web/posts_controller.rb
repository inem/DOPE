module Web
  class PostsController < Web::ApplicationController
    def show
      user_uuid = params[:user_uuid_tail]
      post_uuid = params[:post_uuid_tail]

      # Находим пользователя по UUID
      user = User.find_by(uuid: user_uuid)
      raise ActiveRecord::RecordNotFound unless user

      Current.user = user

      # Находим конкретную версию поста
      @post = Post.find_by(uuid: post_uuid)
      raise ActiveRecord::RecordNotFound unless @post

      # Загружаем родительский пост и версии
      @post = Post.includes(:parent, :versions, :user).find(@post.id)

      render_post
    end

    def latest
      # Находим пользователя по никнейму
      user = User.find_by!(nickname: params[:nickname])
      Current.user = user

      # Находим оригинальный пост по timestamp_id
      original_post = user.posts.find_by!(timestamp_id: params[:timestamp_id])

      # Находим последнюю версию этого поста
      @post = Post.includes(:parent, :versions, :user)
        .where(parent_id: original_post.id)
        .where(latest: true)
        .first || original_post

      render_post
    end

    private

    def render_post
      @content_html = Dope.markdown.render(@post.content)
      render :show, layout: "post"
    end
  end
end
