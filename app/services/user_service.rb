class UserService
  def self.register!(uuid, nickname = nil)
    user = User.find_by(uuid: uuid)

    if !user
      user = User.create!(
        uuid: uuid,
        email: "user-#{uuid[0..7]}@dope.local",
        password: SecureRandom.hex(16),
        nickname: nickname || NicknameGenerator.generate_unique
      )
    end

    user
  end
end
