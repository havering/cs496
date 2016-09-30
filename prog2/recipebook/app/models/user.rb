class User < ApplicationRecord
  include ActiveModel::Validations

  has_many :recipes
  validates :name, presence: true
  validates :username, presence: true

  has_secure_password
end
