class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name,  presence: true,
                    length: { minimum: 4, maximum: 32 }
  validates :email, presence: true,
                    length: { minimum: 5, maximum: 255 },
                    format: { with: /\A(?:[\w\-+]+\.)*[\w\-+]+@(?:[\w\-]+\.)+[a-z]{2,}\Z/i },
                    uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
end
