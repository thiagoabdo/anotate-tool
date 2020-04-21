class Dataset < ApplicationRecord
  has_many :roles
  has_many :users, through: :roles
  has_many :entries
end
