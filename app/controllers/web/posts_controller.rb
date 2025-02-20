module Web
  class PostsController < Web::ApplicationController
    def show
      user_id = params[:user_uuid_tail]
      post_uuid = params[:post_uuid_tail]

      # Находим пользователя по хвосту UUID
      user = User.find_by(id: user_id)
      raise ActiveRecord::RecordNotFound unless user

      Current.user = user

      # Находим пост по хвосту UUID
      @post = Post.find_by(uuid: post_uuid)
      raise ActiveRecord::RecordNotFound unless @post

      # Загружаем родительский пост и версии
      @post = Post.includes(:parent, :versions, :user).find(@post.id)

      @content_html = Dope.markdown.render(@post.content)
      render layout: "post"
    end
  end
end
