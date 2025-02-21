module Web
  class PostsController < Web::ApplicationController
    def show
      user = User.find_by!(nickname: params[:nickname])
      @post = user.posts.includes(:entry, :user).find_by!(uuid: params[:uuid])

      # Рендерим markdown в HTML для маскированного контента
      html_content = Dope.markdown.render(@post.content)
      @masked_content = mask_content(html_content)

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

    def schedule_deletion
      @post = Post.find(params[:id])

      if @post.update(scheduled_for_deletion_at: 1.week.from_now)
        render json: { status: "success" }
      else
        render json: { status: "error" }, status: :unprocessable_entity
      end
    end

    private

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
