class Observation < ApplicationRecord
  belongs_to :dataset
  has_many :attr_values, dependent: :destroy
  has_many :notations, dependent: :destroy
  accepts_nested_attributes_for :attr_values, allow_destroy: true, reject_if: proc { |attr| attr['value'].blank? }
  scope :from_user_naousar, ->(id) { joins(:dataset).merge(Dataset.owned_by(id)) }
end
