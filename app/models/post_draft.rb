class PostDraft
  attr_reader :content, :content_hash, :prefix_hash, :normalized_content

  def initialize(content:)
    @content = content
    @normalized_content = normalize_content(content)
    @content_hash = generate_content_hash(@normalized_content)
    @prefix_hash = generate_prefix_hash(@normalized_content)
  end

  private

  def normalize_content(text)
    text.to_s
      .gsub(/[^\S\n]+/, " ")
      .gsub(/^ +| +$/, "")
  end

  def generate_content_hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def generate_prefix_hash(text)
    prefix = text[0...Dope.config.posts.prefix_length]
    Digest::SHA256.hexdigest(prefix)
  end
end
