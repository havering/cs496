class User < ApplicationRecord
  include ActiveModel::Validations

  has_many :recipes
  validates :name, presence: true
  validates :username, presence: true
  validates :username, uniqueness: true
  validates :password, presence: true

  has_secure_password
end
