module Similarity
  class << self
    def calculate_content_similarity(old_content, new_content)
      old_normalized = old_content.to_s.strip.gsub(/\s+/, ' ')
      new_normalized = new_content.to_s.strip.gsub(/\s+/, ' ')

      if old_normalized == new_normalized
        return 1.0
      end

      # Находим общий префикс
      common_prefix_length = 0
      min_length = [old_normalized.length, new_normalized.length].min
      min_length.times do |i|
        break if old_normalized[i] != new_normalized[i]
        common_prefix_length += 1
      end

      # Считаем similarity с бóльшим весом для начала текста:
      # - Делим на min_length вместо max_length, чтобы не штрафовать за добавление текста
      # - Умножаем на 1.5, чтобы дать больше веса совпадающему началу
      similarity = (common_prefix_length.to_f / min_length) * 1.5
      # Ограничиваем максимум единицей
      [similarity, 1.0].min
    end

    def longest_common_substring(str1, str2)
      return "" if str1.empty? || str2.empty?

      matrix = Array.new(str1.length) { Array.new(str2.length, 0) }
      max_length = 0
      max_end_pos = 0

      str1.each_char.with_index do |char1, i|
        str2.each_char.with_index do |char2, j|
          if char1 == char2
            matrix[i][j] = (i.zero? || j.zero? ? 0 : matrix[i-1][j-1]) + 1
            if matrix[i][j] > max_length
              max_length = matrix[i][j]
              max_end_pos = i
            end
          end
        end
      end

      str1[max_end_pos - max_length + 1..max_end_pos]
    end

    def similar?(old_content, new_content)
      calculate_content_similarity(old_content, new_content) >= Dope.config.posts.similarity_threshold
    end
  end
end