class PostMutator
  def self.create_from_draft(draft, user)
    Post.transaction do
      # Создаем entry для нового поста
      entry = PostEntry.create!(
        user: user,
        timestamp_id: Time.current.strftime("%Y%m%d%H%M%S").to_i.to_s(36)
      )

      post = Post.new(
        content: draft.normalized_content,
        content_hash: draft.content_hash,
        prefix_hash: draft.prefix_hash,
        uuid: SecureRandom.uuid,
        version: 1,
        latest: true,
        user: user,
        entry: entry
      )

      post.save!

      # Обновляем entry чтобы указать на созданный пост
      entry.update!(latest_post: post)

      post
    end
  end

  def self.create_new_version(draft, original, user)
    # Вычисляем схожесть текстов
    levenshtein_distance = Text::Levenshtein.distance(draft.normalized_content, original.content)
    max_length = [ draft.normalized_content.length, original.content.length ].max
    actual_similarity = 1 - (levenshtein_distance.to_f / max_length)

    Post.transaction do
      post = Post.new(
        content: draft.normalized_content,
        content_hash: draft.content_hash,
        prefix_hash: draft.prefix_hash,
        uuid: SecureRandom.uuid,
        parent_id: original.id,
        similarity: actual_similarity,
        version: calculate_version(original),
        latest: true,
        user: user,
        entry: original.entry
      )

      # Помечаем предыдущие версии как неактуальные
      Post.where(parent_id: original.id).update_all(latest: false)
      Post.where(id: original.id).update_all(latest: false)

      post.save!

      # Обновляем entry чтобы указать на новую версию
      original.entry.update!(latest_post: post)

      post
    end
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
end
