class User < ActiveRecord::Base
  validates :Email, presence: true
end
