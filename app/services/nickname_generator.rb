class NicknameGenerator
  VOWELS = %w[a e i o u]
  CONSONANTS = %w[b d f g h j k l m n p r s t v w y z]

  def self.generate
    # Паттерн "согласная-гласная-согласная" (например: "rak", "lem", "vin")
    [
      CONSONANTS.sample,
      VOWELS.sample,
      CONSONANTS.sample
    ].join
  end

  def self.generate_unique
    100.times do
      nickname = generate
      return nickname unless User.exists?(nickname: nickname)
    end

    # Если все попытки исчерпаны, добавляем цифру
    "#{generate}#{rand(9)}"
  end
end
