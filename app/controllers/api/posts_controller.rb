module Api
  class PostsController < ApplicationController
    before_action :authenticate_user

    def create
      post = nil
      draft = PostDraft.new(content: params[:content])

      # Сначала ищем точное совпадение по content_hash среди постов пользователя
      exact_match = Current.user.posts.find_by(content_hash: draft.content_hash)

      if exact_match
        Rails.logger.info "Found exact match by content_hash"
        render json: build_response(exact_match, "Found exact match"), status: :ok
        return
      end

      # Поиск похожих постов
      similar_post = find_similar_post(draft)

      if similar_post
        # Создаем новую версию
        post = PostMutator.create_new_version(draft, similar_post, Current.user)
        render json: build_response(post, "Created new version"), status: :created
      else
        # Создаем новый пост
        post = PostMutator.create_from_draft(draft, Current.user)
        render json: build_response(post, "Created new post"), status: :created
      end
    rescue => e
      Rails.logger.error "Post creation failed: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def find_similar_post(draft)
      Current.user.posts
        .where("created_at > ?", Dope.config.posts.recency_window.ago)
        .order(created_at: :desc)
        .find do |post|
          similarity = Similarity.calculate_content_similarity(
            draft.normalized_content,
            post.content
          )

          Rails.logger.info "Checking post #{post.id}:"
          Rails.logger.info "Age: #{(Time.current - post.created_at).round} seconds"
          Rails.logger.info "Similarity: #{similarity}"

          similarity >= Dope.config.posts.similarity_threshold
        end
    end

    def build_response(post, message)
      {
        url: latest_post_url(post.user.nickname, post.entry.timestamp_id),
        id: post.id,
        version: post.version,
        message: message
      }
    end

    # def post_url(post)
    #   "#{root_url}posts/#{post.user.uuid}/#{post.uuid}"
    # end
  end
end
