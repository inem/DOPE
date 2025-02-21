module Web
  class PostsController < Web::ApplicationController
    def show
      @post = Post.find_by!(uuid: params[:uuid])

      # Рендерим markdown в HTML для маскированного контента
      html_content = Dope.markdown.render(@post.content)
      @masked_content = mask_content(html_content)

      render :show, layout: "post"
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

      # Рендерим markdown в HTML для маскированного контента
      html_content = Dope.markdown.render(@post.content)
      @masked_content = mask_content(html_content)

      render :show, layout: "post"
    end

    def content
      user = User.find_by!(uuid: params[:user_uuid_tail])
      post = user.posts.find_by!(uuid: params[:post_uuid_tail])

      # Рендерим только контент поста
      render plain: Dope.markdown.render(post.content)
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
