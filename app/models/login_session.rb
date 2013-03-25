require "bcrypt"

class LoginSession < ActiveRecord::Base
  EXPIRY = 60 * 60 # 1 hour

  attr_accessor :code

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/

  before_create :generate_code

  alias_attribute :activated, :activated_at
  alias_attribute :terminated, :terminated_at

  def self.create_from_email(email)
    create(email: email)
  end

  def expired?
    DateTime.current.to_i - self.created_at.to_i > EXPIRY
  end

  def activate_session!(code, ip, user_agent)
    if BCrypt::Password.new(hashed_code) == code
      self.activated_at = DateTime.now
      self.ip = ip
      self.user_agent = user_agent
      save
    else
      false
    end
  end

  def kill!
    update_attributes(terminated_at: DateTime.now)
  end

  private

  def generate_code
    self.code = ::SecureRandom.hex(32).to_s
    self.hashed_code = ::BCrypt::Password.create(code)
  end
end
