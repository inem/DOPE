class UserService
  def self.register!(uuid, nickname, port)
    # Check if user already exists
    user = User.find_by(uuid: uuid)

    if user
      # Update existing user's information
      user.update!(
        nickname: nickname,
        local_port: port  # Make sure this line exists to save the port
      )
    else
      # Create a new user
      user = User.create!(
        uuid: uuid,
        nickname: nickname,
        local_port: port,  # Ensure port is being saved
        email: "#{uuid}@example.com",  # Since email is required but we don't have it
        password: SecureRandom.hex(10)  # Generate a random password
      )
    end

    user
  end
end
