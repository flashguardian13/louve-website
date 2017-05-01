class UserPasswordValidator < ActiveModel::Validator
  MIN_PASSPHRASE_WORDS = 4
  MIN_PASSPHRASE_LENGTH = 9

  @@words = nil

  def validate(record)
    unless @@words
      word_file = File.join(File.dirname(__FILE__), 'words.txt')
      @@words = File.read(word_file).scan(/\S+/).map { |x| x.downcase }
    end

    pw = record.password
    pw_down = pw.downcase
    pw_reverse = pw_down.reverse

    if pw_down.include?(record.name.downcase) || pw_reverse.include?(record.name.downcase)
      record.errors[:password].push("cannot contain the username.")
    end

    if @@words.include?(pw_down) || @@words.include?(pw_reverse)
      record.errors[:password].push("cannot be a dictionary word.")
    end

    if @@words.include?(pw_down[1..-1]) || @@words.include?(pw_down[0...-1]) ||
      @@words.include?(pw_reverse[1..-1]) || @@words.include?(pw_reverse[0...-1])
      record.errors[:password].push("cannot be a dictionary word and a character.")
    end

    if pw_down.match(/(.)\1{3,}/) || pw_down.match(/(..)\1{3,}/) || pw_down.match(/(...)\1{2,}/) || pw_down.match(/(....)\1/)
      record.errors[:password].push("cannot repeat the same characters too many times.")
    end

    run_count = 0
    (1...pw_down.length).each do |i|
      if (pw_down[i - 1].ord - pw_down[i].ord).abs == 1
        run_count += 1
      else
        run_count = 0
      end
      if run_count >= 3
        record.errors[:password].push("cannot contain a sequence.")
        break
      end
    end

    if %w(1q2w3e4r 1q2w3e4r5t 18atcskd2w 3rjs1la7qe).include?(pw_down)
      record.errors[:password].push("cannot be a commonly used password.")
    end

    if pw_down.match(/qwerty/) || pw_down.match(/asdf/) || pw_down.match(/zxcv/) || pw_down.match(/zaq1/)
      record.errors[:password].push("cannot contain a keyboard-based sequence.")
    end

    if pw.match(/ /)
      record.errors[:password].push("phrases must contain at least #{MIN_PASSPHRASE_WORDS} words.") unless pw.split(/\s+/).length >= MIN_PASSPHRASE_WORDS
      record.errors[:password].push("phrases must be at least #{MIN_PASSPHRASE_LENGTH} characters long.") unless pw.length >= MIN_PASSPHRASE_LENGTH
    else
      record.errors[:password].push('must contain at least one lowercase letter.') unless pw.match(/[a-z]/)
      record.errors[:password].push('must contain at least one uppercase letter.') unless pw.match(/[A-Z]/)
      record.errors[:password].push('must contain at least one digit.') unless pw.match(/[0-9]/)
    end
  end
end

class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name,  presence: true,
                    length: { minimum: 4, maximum: 32 }
  validates :email, presence: true,
                    length: { minimum: 5, maximum: 255 },
                    format: { with: /\A(?:[\w\-+]+\.)*[\w\-+]+@(?:[\w\-]+\.)+[a-z]{2,}\Z/i },
                    uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true
  validates :password,  presence: true,
                        confirmation: true,
                        length: { minimum: 8, maximum: 32 }
  has_secure_password
  validates_with UserPasswordValidator
end
