class Recipe < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  validates :name, presence: true
  validates :description, presence: true
  validates :instructions, presence: true
  validates :servings, presence: true
  validates :cook_time, presence: true

end
