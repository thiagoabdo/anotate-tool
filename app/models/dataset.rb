class Dataset < ApplicationRecord
  has_many :roles, dependent: :destroy
  has_many :users, through: :roles
  has_many :entries, dependent: :destroy
  has_many :notations, through: :entries, dependent: :destroy
  has_many :observations, dependent: :destroy

  scope :owned_by, ->(id) { joins(:roles).merge(Role.owned_by(id)) }
  scope :participant, ->(id) { joins(:roles).merge(Role.all_by(id))}
end
