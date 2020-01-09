class Account < ActiveRecord::Base
  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\z/i
  validates :email, presence: true, format: EMAIL_REGEX
end
