require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    data = {
      name: "Example User",
      email: "user@example.com",
      password_digest: 'not a real digest',
      is_admin: false
    }
    @user = User.new(data)

    data = {
      name: "Another Example User",
      email: "user2@example.com",
      password_digest: 'still not a real digest',
      is_admin: true
    }
    @duplicate_user = User.new(data)
  end

  it 'is valid' do
    expect(@user).to be_valid
  end

  describe '#name' do
    it 'is present' do
      @user.name = '          '
      expect(@user).not_to be_valid
    end

    it 'is between 4 and 32 characters long' do
      bad_usernames = %w(Bob God A Z Ix pi fro)
      bad_usernames.each do |name|
        @user.name = name
        expect(@user).not_to be_valid
      end

      @user.name = 'abcd'
      expect(@user).to be_valid

      @user.name = 'abcd' * 8
      expect(@user).to be_valid

      @user.name = 'abcd' * 8 + 'z'
      expect(@user).not_to be_valid
    end
  end

  describe '#email' do
    it 'is present' do
      @user.email = '          '
      expect(@user).not_to be_valid
    end

    it 'is between 5 and 255 characters long' do
      bad_emails = %w(a@b ce@d)
      bad_emails.each do |email|
        @user.email = email
        expect(@user).not_to be_valid
      end

      @user.email = 'admin@boogie.com'
      expect(@user).to be_valid

      @user.email = 'xylophones@yesmail.zm'
      expect(@user).to be_valid

      @user.email = 'nananana' * 30 + '@batman.com'
      expect(@user).to be_valid

      @user.email = 'nananana' * 31 + '@batman.com'
      expect(@user).not_to be_valid
    end

    it 'accepts valid email addresses' do
      good_emails = %w(
        email@example.com
        firstname.lastname@example.com
        email@subdomain.example.com
        firstname+lastname@example.com
        1234567890@example.com
        email@example-one.com
        _______@example.com
        email@example.name
        email@example.museum
        email@example.co.jp
        firstname-lastname@example.com
        email@-example.com
        email@example.web
      )
      good_emails.each do |email|
        @user.email = email
        expect(@user).to be_valid
      end
    end

    it 'denies questionable email addresses' do
      weird_emails = %w(
        email@123.123.123.123
        email@[123.123.123.123]
        "email"@example.com
      )
      weird_emails.each do |email|
        @user.email = email
        expect(@user).not_to be_valid
      end
    end

    it 'denies invalid email addresses' do
      bad_emails = %w(
        plainaddress
        #@%^%#$@#$@#.com
        @example.com
        email.example.com
        email@example@example.com
        .email@example.com
        email.@example.com
        email..email@example.com
        ?????@example.com
        email@example
        email@111.222.333.44444
        email@example..com
        Abc..123@example.com
        "(),:;<>[\]@example.com
        just"not"right@example.com
      ) + [
        'Joe Smith <email@example.com>',
        'email@example.com (Joe Smith)',
        'this\ is"really"not\allowed@example.com'
      ]
      bad_emails.each do |email|
        @user.email = email
        expect(@user).not_to be_valid
      end
    end

    context 'when a user is saved' do
      before(:each) do
        @user.save
      end

      it 'requires emails to be unique' do
        duplicate_user = @duplicate_user.dup
        duplicate_user.email = @user.email
        expect(duplicate_user).not_to be_valid
        duplicate_user.email.upcase!
        expect(duplicate_user).not_to be_valid
      end

      after(:each) do
        @user.destroy
      end
    end
  end

  describe '#password_digest' do
    it 'is present' do
      @user.password_digest = '          '
      expect(@user).not_to be_valid
    end
  end

  describe '#is_admin' do
    #~ it 'is present' do
      #~ @user.is_admin = nil
      #~ expect(@user).not_to be_valid
    #~ end
  end
end
