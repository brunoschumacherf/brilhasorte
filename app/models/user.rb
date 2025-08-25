class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :referred_users, class_name: "User", foreign_key: "referred_by_id"
  belongs_to :referred_by, class_name: "User", foreign_key: "referred_by_id", optional: true
  has_many :deposits
  has_many :withdrawals
  has_many :games
  has_many :tickets
  has_many :ticket_replies
  has_many :mines_games
  has_many :plinko_games
  has_many :tower_games
  has_many :limbo_games


  validates :full_name, presence: true
validates :email, presence: { message: "Não pode ficar em branco" },
                  uniqueness: { message: "Email Invalido" },
                  format: { with: URI::MailTo::EMAIL_REGEXP, message: "Não é válido" }
  validates :cpf, presence: true, uniqueness: true
  validates :phone_number, presence: true
  validates :birth_date, presence: true

  validate :cpf_must_be_valid
  validate :must_be_over_18

  after_create :generate_referral_code

  def can_claim_daily_free_game?
    self.last_free_game_claimed_at.nil? || self.last_free_game_claimed_at < 24.hours.ago
  end

  def can_claim_daily_game
    can_claim_daily_free_game?
  end

  private

  def generate_referral_code
    loop do
      name_part = self.email.split('@').first.upcase.gsub(/[^A-Z]/, '').first(5)
      random_part = SecureRandom.random_number(1000..9999).to_s
      self.referral_code = "#{name_part}#{random_part}"
      break unless User.exists?(referral_code: self.referral_code)
    end
    self.update_column(:referral_code, self.referral_code)
  end

  def cpf_must_be_valid
    return if cpf.blank?
    unless CPF.valid?(cpf)
      errors.add(:cpf, "Inválido")
    end
  end

  def must_be_over_18
    return if birth_date.blank?
    if birth_date > 18.years.ago.to_date
      errors.add(:birth_date, "Deve ser maior de 18 anos")
    end
  end

end
