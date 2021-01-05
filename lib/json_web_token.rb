require 'jwt'

class JsonWebToken
    class << self
        def encode(payload, exp = 24.hours.from_now)
            raise StandardError.new("payload is nil") unless payload / raise StandardError.new("secret key is nil") unless Rails.application.secrets.secret_key_base
            payload[:exp] = exp.to_i
            JWT.encode(payload, Rails.application.secrets.secret_key_base)
        end
    
        def decode(token)
            body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
            HashWithIndifferentAccess.new body
        rescue
            nil
        end
    end
end