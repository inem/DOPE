class JwtHandler
  class << self
    def generate(user)
      JWT.encode(
        {
          uuid: user.uuid,
          exp: 30.days.from_now.to_i
        },
        Rails.application.credentials.secret_key_base,
        "HS256"
      )
    end

    def decode(token)
      JWT.decode(
        token,
        Rails.application.credentials.secret_key_base,
        true,
        algorithm: "HS256"
      ).first
    rescue JWT::DecodeError => e
      Rails.logger.error "Token decode error: #{e.message}"
      nil
    end
  end
end