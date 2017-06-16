class Chef < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_save { self.email = email.downcase }

  validates :chefname, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 50 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  
  has_many :recipes, dependent: :destroy
  has_secure_password
end
