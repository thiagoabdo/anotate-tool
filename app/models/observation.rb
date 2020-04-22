class Observation < ApplicationRecord
  belongs_to :dataset
  has_many :attr_values, dependent: :destroy
  has_many :notations, dependent: :destroy
  scope :from_user_naousar, ->(id) { joins(:dataset).merge(Dataset.owned_by(id)) }
end
