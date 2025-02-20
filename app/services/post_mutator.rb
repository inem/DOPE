class PostMutator
  def self.create_from_draft(draft, user)
    post = Post.new(
      content: draft.normalized_content,
      content_hash: draft.content_hash,
      prefix_hash: draft.prefix_hash,
      uuid: SecureRandom.uuid,
      version: 1,
      latest: true,
      user: user
    )

    post.save!
    post
  end

  def self.create_new_version(draft, original, user)
    # Вычисляем схожесть текстов
    levenshtein_distance = Text::Levenshtein.distance(draft.normalized_content, original.content)
    max_length = [ draft.normalized_content.length, original.content.length ].max
    actual_similarity = 1 - (levenshtein_distance.to_f / max_length)

    post = Post.new(
      content: draft.normalized_content,
      content_hash: draft.content_hash,
      prefix_hash: draft.prefix_hash,
      uuid: SecureRandom.uuid,
      parent_id: original.id,
      similarity: actual_similarity,
      version: calculate_version(original),
      latest: true,
      user: user
    )

    Post.transaction do
      # Помечаем все связанные посты как неактуальные
      mark_posts_as_not_latest(post.parent_id)
      post.save!
    end

    post
  end

  private

  def self.calculate_version(original)
    version_count = 1 # Начинаем с 1 (оригинал)
    current = original

    # Идем по цепочке parent_id до оригинала
    while current.parent_id
      version_count += 1
      current = Post.find(current.parent_id)
    end

    version_count + 1
  end

  def self.mark_posts_as_not_latest(parent_id)
    # Помечаем предыдущие версии как неактуальные
    Post.where(parent_id: parent_id).update_all(latest: false)
    # Помечаем оригинальный пост как неактуальный
    Post.where(id: parent_id).update_all(latest: false)
  end
end
