class Similarity
  def self.calculate_content_similarity(text1, text2)
    Text::Levenshtein.similarity(text1, text2)
  end
end
