include ActiveModel::SecurePassword

module RailsTokenAuth
  module Authenticatable
    def regenerate_auth_token
      self.update_attribute(:auth_token, SecureRandom.base58(24))
    end

    def destroy_auth_token
      self.update_attribute(:auth_token, nil)
    end

    def self.included(base)
      if defined? Mongoid
        base.send(:field, RTA.auth_field_name,  {type: String})
        base.send(:field, :password_digest,     {type: String})
        base.send(:field, :auth_token,          {type: String})
      end

      base.send(:validates, RTA.auth_field_name, {presence: true, uniqueness: true})
      base.send(:validates, RTA.auth_field_name, {email: true}) if RTA.auth_field_email

      base.send(:has_secure_password)
    end
  end
end
