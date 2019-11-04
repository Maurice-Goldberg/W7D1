# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    attr_reader :password
    validates :user_name, :password_digest, :session_token, presence: true
    validates :session_token, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true }
    after_initialize :ensure_session_token

    has_many :cats

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def is_password?(pw)
        bcrypted_pw = BCrypt::Password.new(self.password_digest)
        bcrypted_pw.is_password?(pw)
    end

    def password=(pw)
        self.password_digest = BCrypt::Password.create(pw).to_s
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        unless self.session_token
            self.reset_session_token!
        end
    end
end
