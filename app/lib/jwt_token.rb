class JwtToken
  def self.extract_uuid(header)
    token = header.split(' ').last if header
    return nil if !token

    begin
      decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
      decoded.first['uuid']
    rescue JWT::DecodeError
      nil
    end
  end
end
