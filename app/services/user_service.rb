class UserService
  def self.register!(uuid)
    user = User.find_by(uuid: uuid)

    if !user
      user = User.create!(
        uuid: uuid,
        email: "user-#{uuid[0..7]}@dope.local",
        password: SecureRandom.hex(16)
      )
    end

    user
  end
end
