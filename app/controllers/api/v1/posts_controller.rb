module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!

      def create
        post = current_user.posts.new(content: params[:content])

        if post.save
          render json: { url: post_url(post) }, status: :created
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def post_url(post)
        "#{root_url}posts/#{current_user.id}/#{post.uuid}"
      end
    end
  end
end
