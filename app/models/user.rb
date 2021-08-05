class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  before_create :create_activation_digest

  PERMITTED_FIELDS = [:name, :email, :birthday, :gender, :password,
                      :password_confirmation].freeze

  PERMITTED_PASSWORD_FIELDS = [:password, :password_confirmation].freeze

  validates :name, presence: true,
            length: {
              maximum: Settings.validate.name.max_length
            }
  validates :email, presence: true,
            length: {
              minimum: Settings.validate.email.min_length,
              maximum: Settings.validate.email.max_length
            },
            format: {with: Settings.validate.email.format},
            uniqueness: {case_sensitive: Settings.validate.email.case_sensitive}

  validates :password, presence: true,
            length: {
              minimum: Settings.validate.password.min_length
            },
            allow_nil: true

  has_secure_password

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  # Activates an account.
  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def reset_digest_after_update
    update_attribute :reset_digest, nil
  end

  def password_reset_expired?
    reset_sent_at < Settings.reset_pass_expired_time.hours.ago
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
