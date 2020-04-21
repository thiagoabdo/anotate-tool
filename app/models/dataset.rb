class Dataset < ApplicationRecord
  has_many :roles
  has_many :users, through: :roles
  has_many :entries
  has_many :notations, through: :entries
  has_many :observations
end
