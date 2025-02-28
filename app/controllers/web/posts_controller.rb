module Web
  class PostsController < Web::ApplicationController
    before_action :set_post, only: [ :destroy, :restore, :publish, :unpublish ]
    # before_action :check_ownership, only: [ :destroy, :restore, :publish, :unpublish ]

    rescue_from StateMachines::InvalidTransition do |exception|
      redirect_back fallback_location: root_path, alert: "Cannot change post state: #{exception.message}"
    end

    def show
      user = User.find_by!(nickname: params[:nickname])
      @post = user.posts.includes(:entry, :user).find_by!(uuid: params[:uuid])

      # Рендерим markdown в HTML
      html_content = Dope.markdown.render(@post.content)

      # Если пост публичный, показываем контент напрямую
      if @post.public?
        @masked_content = html_content
      else
        @masked_content = mask_content(html_content)
      end

      render :show, layout: "post"
    end

    def latest
      # Находим пользователя по никнейму
      user = User.find_by!(nickname: params[:nickname])
      Current.user = user

      # Находим entry по timestamp_id и берем последнюю версию
      @entry = user.post_entries.find_by!(timestamp_id: params[:timestamp_id])
      @post = @entry.latest_post

      # Рендерим markdown в HTML для маскированного контента
      html_content = Dope.markdown.render(@post.content)
      @masked_content = mask_content(html_content)

      render :show, layout: "post"
    end

    def content
      user = User.find_by!(nickname: params[:nickname])
      post = user.posts.find_by!(uuid: params[:uuid])

      # Рендерим только контент поста
      render plain: Dope.markdown.render(post.content)
    end

    def destroy
      @post.schedule_for_deletion
      redirect_to post_path(@post.user.nickname, @post.uuid), notice: "Post scheduled for deletion"
    end

    def restore
      @post.restore
      redirect_to post_path(@post.user.nickname, @post.uuid), notice: "Post restored"
    end

    def publish
      @post.publish
      redirect_to post_path(@post.user.nickname, @post.uuid), notice: "Post published"
    end

    def unpublish
      @post.unpublish
      redirect_to post_path(@post.user.nickname, @post.uuid), notice: "Post unpublished"
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def check_ownership
      redirect_to root_path, alert: "Not authorized" unless @post.user == Current.user
    end

    def mask_content(html_content)
      doc = Nokogiri::HTML::DocumentFragment.parse(html_content)

      # Удаляем только первый h1/h2 заголовок
      doc.at_css("h1, h2")&.remove

      doc.traverse do |node|
        if node.text? && !node.text.strip.empty? && node.parent.name != "pre"
          node.content = node.text.gsub(/[^\s]/, "▀")
        end
      end

      doc.to_html
    end
  end
end
