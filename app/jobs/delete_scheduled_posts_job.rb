class DeleteScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform
    Post.where("scheduled_for_deletion_at <= ?", Time.current).find_each do |post|
      post.destroy
    end
  end
end
