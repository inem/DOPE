class UserService
  def self.register!(uuid, nickname = nil, port = nil)
    user = User.find_by(uuid: uuid)

    if !user
      user = User.create!(
        uuid: uuid,
        email: "user-#{uuid[0..7]}@dope.local",
        password: SecureRandom.hex(16),
        nickname: nickname || NicknameGenerator.generate_unique,
        local_port: port
      )
    elsif port && user.local_port != port
      # Обновляем порт если он изменился
      user.update!(local_port: port)
    end

    user
  end
end
