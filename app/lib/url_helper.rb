module UrlHelper
  def uuid_tail(uuid)
    uuid.split('-').last
  end

  def build_chunk_url(post)
    user_uuid_tail = uuid_tail(Current.user.uuid)
    post_uuid_tail = uuid_tail(post.uuid)

    if Rails.env.production?
      "http://#{request.host}/posts/#{user_uuid_tail}/#{post_uuid_tail}"
    else
      "http://#{request.host}:#{Dope.config.url.port}/posts/#{user_uuid_tail}/#{post_uuid_tail}"
    end
  end
end